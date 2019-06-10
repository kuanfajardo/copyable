import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:dart_style/dart_style.dart';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/emitter.dart';
import 'package:source_gen/source_gen.dart';

import 'package:copyable_generator/annotations.dart';

class CopierGenerator extends GeneratorForAnnotation<BuildCopier> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return this.generateForAnnotatedClassElement(element, annotation, buildStep);
    }
  }

  String generateForAnnotatedClassElement(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
    element.visitChildren(visitor);

    String className = element.name;
    String copierName = className + 'Copier';

    List<Parameter> params = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) => Parameter((b) => b
      ..name = entry.key
      ..type = refer(entry.value.name)
      ..named = true))
        .toList();

    String paramCode = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) => '${entry.key}: ${entry.key}')
        .toList()
        .join(', ');

    String detailedParamCode = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) =>
    '${entry.key} : ${entry.key} ??'
        ' master?.${entry.key} ?? defaultMaster.${entry.key}')
        .toList()
        .join(', ');

    String internalCopyCode = '''
      master = master ?? this.master;
      $className new$className = $className(
        $detailedParamCode
      );
      
      return resolve ? new$className : $copierName(new$className);
    ''';

    final Method internalCopy = Method((b) => b
      ..name = 'internalCopy'
      ..returns = refer('dynamic')
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(className)))
      ..optionalParameters.add(Parameter((b) => b
        ..name = 'resolve'
        ..type = refer('bool')
        ..named = true
        ..defaultTo = Code('false')))
      ..optionalParameters.addAll(params)
      ..body = Code(internalCopyCode));

    final Method copy = Method((b) => b
      ..name = 'copy'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(className)))
      ..returns = refer(copierName)
      ..body = Code('''
            return this.internalCopy(
              master,
              resolve: false,
            ) as $copierName;
        '''));

    final Method copyAndResolve = Method((b) => b
      ..name = 'copyAndResolve'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(className)))
      ..returns = refer(className)
      ..body = Code('''
          return this.internalCopy(
            master,
            resolve: true,
          ) as $className;
        '''));

    final Method copyWith = Method((b) => b
      ..name = 'copyWith'
      ..optionalParameters.addAll(params)
      ..returns = refer(copierName)
      ..body = Code('''
            return this.internalCopy(
              this.master,
              resolve: false,
              $paramCode
            ) as $copierName;
        '''));

    final Method copyWithAndResolve = Method((b) => b
      ..name = 'copyWithAndResolve'
      ..optionalParameters.addAll(params)
      ..returns = refer(className)
      ..body = Code('''
            return this.internalCopy(
              this.master,
              resolve: true,
              $paramCode
            ) as $className;
        '''));

    final Method resolve = Method((b) => b
      ..name = 'resolve'
      ..returns = refer(className)
      ..body = Code('return this.master;'));

    final Constructor constructor = Constructor((b) =>
    b..optionalParameters.add(Parameter((b) => b..name = 'this.master')));

    final Field master = Field((b) => b
      ..name = 'master'
      ..type = refer(className));

    final Method defaultMaster = Method((b) => b
      ..name = 'defaultMaster'
      ..returns = refer(className)
      ..type = MethodType.getter
      ..body = Code('''
        // TODO: Implement default
        return null;
      '''));

    final Class copyable = Class((b) => b
      ..name = copierName
      ..implements.add(refer('Copier<$className>'))
      ..fields.add(master)
      ..constructors.add(constructor)
      ..methods.addAll([
        defaultMaster,
        internalCopy,
        copy,
        copyAndResolve,
        copyWith,
        copyWithAndResolve,
        resolve,
      ]));

    // Generate code and return
    final DartEmitter emitter = DartEmitter();
    final String generatedCode = '${copyable.accept(emitter)}';
    return DartFormatter().format(generatedCode);
  }
}

class CopyableGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    List<VariableElement> metas = [];
    library.allElements.forEach((Element e) {
      if (e is VariableElement) {
        if (e.type.name == 'CopyMeta') {
          metas.add(e);
          return;
        }
      }
    });

    return metas.map((VariableElement meta) => this.generateFromVariableElement
      (meta)).toList().join('\n\n');
  }

  String generateFromVariableElement(VariableElement e) {
    DartObject meta = e.computeConstantValue();

    String baseName = meta.getField('baseClass').toStringValue();
    String prefix = meta.getField('prefix').toStringValue();
    Map<String, String> fields = meta
        .getField('fields')
        .toMapValue()
        .map(
            (DartObject key, DartObject value) =>
                MapEntry(
                    key.toStringValue(),
                    value.toStringValue()
                )
        );

    String className = prefix + baseName;

    final List<Parameter> fieldParams = fields.entries.map((MapEntry<String,
        String> entry) {
      return Parameter((b) => b
        ..name = entry.key
        ..type = refer(entry.value)
        ..named = true
      );
    }).toList();

    String paramCode = fieldParams.map((Parameter p) => '${p.name} : ${p
        .name}').toList().join(', ');

    String detailedParamCode = fieldParams
        .map((Parameter p) =>
    '${p.name} : ${p.name} ??'
        ' master?.${p.name}')
        .toList()
        .join(', ');

    Code _copyCode = Code('''
      $baseName new$baseName = $baseName(
        $detailedParamCode
      );
      
      return $className.from(new$baseName);
    ''');

    final Method copy = Method((b) => b
      ..name = 'copy'
      ..returns = refer(className)
      ..body = Code('''
        return this._copy(this.master);
      ''')
    );

    final Method copyFrom = Method((b) => b
      ..name = 'copyFrom'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(baseName)
      ))
      ..returns = refer(className)
      ..body = Code('''
        return this._copy(master);
      ''')
    );

    final Method copyWith = Method((b) => b
      ..name = 'copyWith'
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(className)
      ..body = Code('''
        return this._copy(null, $paramCode);
      ''')
//      ..annotations.add(Expression)
    );

    final Method _copy = Method((b) => b
      ..name = '_copy'
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = 'master'
          ..type = refer(baseName)
        ),
      )
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(className)
      ..body = _copyCode
    );

    final Field masterField = Field((b) => b
      ..name = 'master'
      ..type = refer(baseName)
      ..modifier = FieldModifier.final$
    );

    final Constructor propertyConstructor = Constructor((b) => b
      ..optionalParameters.addAll(fieldParams)
      ..initializers.add(Code('''
        this.master = $baseName($paramCode)
      '''))
    );

    final Constructor fromExistingConstructor = Constructor((b) => b
      ..name = 'from'
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = 'master'
          ..type = refer(baseName)
        )
      )
      // Need to use initializer instead of just required param because
      // source_gen creates `Constructor(Class this.master)` instead of just
      // `Constructor(this.master)`
      ..initializers.add(Code('this.master = master'))
    );

    final Class copyable = Class((b) => b
      ..name = className
      ..constructors.addAll([
        propertyConstructor,
        fromExistingConstructor,
      ])
      ..fields.add(masterField)
      ..methods.addAll([
        copy,
        copyFrom,
        copyWith,
        _copy
      ])
      ..extend = refer(baseName)
      ..implements.add(refer('Copyable<$baseName>'))
    );

    // Generate code and return
    final DartEmitter emitter = DartEmitter();
    final String generatedCode = '${copyable.accept(emitter)}';
    return DartFormatter().format(generatedCode);
  }
}

class CopyFunctionsGenerator extends GeneratorForAnnotation<CopyFunctions> {
  @override
  String generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return this.generateForAnnotatedClassElement(element, annotation,
          buildStep);
    }

    return null;
  }

  String generateForAnnotatedClassElement(ClassElement element, 
      ConstantReader annotation, BuildStep buildStep) {
    String className = element.name;
    SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
    element.visitChildren(visitor);

    String fieldParams = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) => '${entry.value} ${entry
        .key}')
        .toList()
        .join(', ');

    String paramCode = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) => '${entry.key}: ${entry.key}')
        .toList()
        .join(', ');

    String newParamCode = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) =>
    '${entry.key} : ${entry.key} ??'
        ' master?.${entry.key}')
        .toList()
        .join(', ');

    final String copy = '''
      @override
      $className copy() => _copy(this);
    ''';

    final String copyFrom = '''
      @override
      $className copyFrom($className master) => _copy(master);
    ''';

    final String copyWith = '''
      @override
      $className copyWith({$fieldParams}) => _copy(null, $paramCode);
    ''';

    final String _copy = '''
      $className _copy($className master, {$fieldParams}) {
        return $className($newParamCode);
      }
    ''';

    String methodsString = [copy, copyFrom, copyWith, _copy].join('\n');
    return '''/*
    Copy/Paste these methods into your class! Make sure to remember to 
    $methodsString
    */''';
  }
}

class SimpleFieldElementVisitor extends SimpleElementVisitor {
  Map<String, DartType> fields = {};

  @override
  visitFieldElement(FieldElement element) {
    this.fields[element.name] = element.type;
  }
}
