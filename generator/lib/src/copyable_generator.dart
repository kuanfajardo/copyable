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

// Local, copier
class CopierGenerator extends GeneratorForAnnotation<BuildCopier> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return this.generateForAnnotatedClassElement(element, annotation, buildStep);
    }

    return null;
  }

  String generateForAnnotatedClassElement(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
    element.visitChildren(visitor);

    String baseClassName = element.name;
    String newClassName = baseClassName + 'Copier';

    Map<String, String> fields = visitor.fields
        .map((String fieldName, DartType fieldType) => MapEntry(fieldName,
        fieldType.name));

    Class copier = generateCopier(
      baseClassName: baseClassName,
      newClassName: newClassName,
      fields: fields
    );

    // Generate code and return
    final DartEmitter emitter = DartEmitter();
    final String generatedCode = '${copier.accept(emitter)}';
    return DartFormatter().format(generatedCode);
//
//    String paramCode = visitor.fields.entries
//        .map((MapEntry<String, DartType> entry) => '${entry.key}: ${entry.key}')
//        .toList()
//        .join(', ');
//
//    String detailedParamCode = visitor.fields.entries
//        .map((MapEntry<String, DartType> entry) =>
//    '${entry.key} : ${entry.key} ??'
//        ' master?.${entry.key} ?? defaultMaster.${entry.key}')
//        .toList()
//        .join(', ');
//
//    String internalCopyCode = '''
//      master = master ?? this.master;
//      $className new$className = $className(
//        $detailedParamCode
//      );
//
//      return resolve ? new$className : $copierName(new$className);
//    ''';
//
//    final Method internalCopy = Method((b) => b
//      ..name = 'internalCopy'
//      ..returns = refer('dynamic')
//      ..requiredParameters.add(Parameter((b) => b
//        ..name = 'master'
//        ..type = refer(className)))
//      ..optionalParameters.add(Parameter((b) => b
//        ..name = 'resolve'
//        ..type = refer('bool')
//        ..named = true
//        ..defaultTo = Code('false')))
//      ..optionalParameters.addAll(params)
//      ..body = Code(internalCopyCode));
//
//    final Method copy = Method((b) => b
//      ..name = 'copy'
//      ..requiredParameters.add(Parameter((b) => b
//        ..name = 'master'
//        ..type = refer(className)))
//      ..returns = refer(copierName)
//      ..body = Code('''
//            return this.internalCopy(
//              master,
//              resolve: false,
//            ) as $copierName;
//        '''));
//
//    final Method copyAndResolve = Method((b) => b
//      ..name = 'copyAndResolve'
//      ..requiredParameters.add(Parameter((b) => b
//        ..name = 'master'
//        ..type = refer(className)))
//      ..returns = refer(className)
//      ..body = Code('''
//          return this.internalCopy(
//            master,
//            resolve: true,
//          ) as $className;
//        '''));
//
//    final Method copyWith = Method((b) => b
//      ..name = 'copyWith'
//      ..optionalParameters.addAll(params)
//      ..returns = refer(copierName)
//      ..body = Code('''
//            return this.internalCopy(
//              this.master,
//              resolve: false,
//              $paramCode
//            ) as $copierName;
//        '''));
//
//    final Method copyWithAndResolve = Method((b) => b
//      ..name = 'copyWithAndResolve'
//      ..optionalParameters.addAll(params)
//      ..returns = refer(className)
//      ..body = Code('''
//            return this.internalCopy(
//              this.master,
//              resolve: true,
//              $paramCode
//            ) as $className;
//        '''));
//
//    final Method resolve = Method((b) => b
//      ..name = 'resolve'
//      ..returns = refer(className)
//      ..body = Code('return this.master;'));
//
//    final Constructor constructor = Constructor((b) =>
//    b..optionalParameters.add(Parameter((b) => b..name = 'this.master')));
//
//    final Field master = Field((b) => b
//      ..name = 'master'
//      ..type = refer(className));
//
//    final Method defaultMaster = Method((b) => b
//      ..name = 'defaultMaster'
//      ..returns = refer(className)
//      ..type = MethodType.getter
//      ..body = Code('''
//        // TODO: Implement default
//        return null;
//      '''));
//
//    final Class copyable = Class((b) => b
//      ..name = copierName
//      ..implements.add(refer('Copier<$className>'))
//      ..fields.add(master)
//      ..constructors.add(constructor)
//      ..methods.addAll([
//        defaultMaster,
//        internalCopy,
//        copy,
//        copyAndResolve,
//        copyWith,
//        copyWithAndResolve,
//        resolve,
//      ]));
//
//    // Generate code and return
//    final DartEmitter emitter = DartEmitter();
//    final String generatedCode = '${copyable.accept(emitter)}';
//    return DartFormatter().format(generatedCode);
  }
}

// Foreign, copyable
class CopyableGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    List<VariableElement> metas = [];
    library.allElements.forEach((Element e) {
      if (e is VariableElement) {
        if (e.type.name == 'CopyableMeta') {
          metas.add(e);
          return;
        }
      }
    });

    return metas.map((VariableElement meta) => this.generateFromVariableElement
      (meta)).toList().join('\n\n');
  }

  String generateFromVariableElement(VariableElement e) {
    // (super) field is where DartObject stores fields of superclass (i.e.
    // _CopyMeta)
    DartObject meta = e.computeConstantValue().getField('(super)');

    String import = meta.getField('import').toStringValue();
    String baseClassName = meta.getField('baseClassName').toStringValue();
    String newClassName = meta.getField('newClassName').toStringValue();
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
      $baseClassName new$baseClassName = $baseClassName(
        $detailedParamCode
      );
      
      return $newClassName.from(new$baseClassName);
    ''');

    final Method copy = Method((b) => b
      ..name = 'copy'
      ..returns = refer(newClassName)
      ..body = Code('''
        return this._copy(this.master);
      ''')
    );

    final Method copyFrom = Method((b) => b
      ..name = 'copyFrom'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(baseClassName)
      ))
      ..returns = refer(newClassName)
      ..body = Code('''
        return this._copy(master);
      ''')
    );

    final Method copyWith = Method((b) => b
      ..name = 'copyWith'
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(newClassName)
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
          ..type = refer(baseClassName)
        ),
      )
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(newClassName)
      ..body = _copyCode
    );

    final Field masterField = Field((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)
      ..modifier = FieldModifier.final$
    );

    final Constructor propertyConstructor = Constructor((b) => b
      ..optionalParameters.addAll(fieldParams)
      ..initializers.add(Code('''
        this.master = $baseClassName($paramCode)
      '''))
    );

    final Constructor fromExistingConstructor = Constructor((b) => b
      ..name = 'from'
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = 'master'
          ..type = refer(baseClassName)
        )
      )
      // Need to use initializer instead of just required param because
      // source_gen creates `Constructor(Class this.master)` instead of just
      // `Constructor(this.master)`
      ..initializers.add(Code('this.master = master'))
    );

    final Class copyable = Class((b) => b
      ..name = newClassName
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
      ..extend = refer(baseClassName)
      ..implements.add(refer('Copyable<$baseClassName>'))
    );

    final List<Directive> imports = [
      Directive.import(import),
      Directive.import('package:copier/copier.dart'),
    ];

    final Library lib = Library((b) => b
      ..directives.addAll(imports)
      ..body.add(copyable)
    );

    // Generate code and return
    final DartEmitter emitter = DartEmitter();
    final String generatedCode = '${lib.accept(emitter)}';
    return DartFormatter().format(generatedCode);
  }
}

// Local, copyable
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
        .join(',\n');

    String paramCode = visitor.fields.entries
        .map((MapEntry<String, DartType> entry) => '${entry.key}: ${entry.key}')
        .toList()
        .join(',\n');

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
      $className copyWith({\n$fieldParams}) => _copy(null,\n$paramCode);
    ''';

    final String _copy = '''
      $className _copy($className master, {\n$fieldParams}) {
        return $className(\n$newParamCode);
      }
    ''';

    String methodsString = [copy, copyFrom, copyWith, _copy].join('\n');
    return '''/*
    Copy/Paste these methods into your class! Make sure to remember to 
    $methodsString
    */''';
  }
}

// Foreign, copier
class ForeignCopierGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    List<VariableElement> metas = [];
    library.allElements.forEach((Element e) {
      if (e is VariableElement) {
        if (e.type.name == 'CopierMeta') {
          metas.add(e);
          return;
        }
      }
    });

    return metas.map((VariableElement meta) => this.generateFromVariableElement
      (meta)).toList().join('\n\n');
  }
  
  String generateFromVariableElement(VariableElement e) {
    // (super) field is where DartObject stores fields of superclass (i.e.
    // _CopyMeta)
    DartObject meta = e.computeConstantValue().getField('(super)'); //

    String import = meta.getField('import').toStringValue();
    String baseClassName = meta.getField('baseClassName').toStringValue();
    String newClassName = meta.getField('newClassName').toStringValue();
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

    Class copier = generateCopier(
      baseClassName: baseClassName,
      newClassName: newClassName,
      fields: fields
    );

    final List<Directive> imports = [
      Directive.import(import),
      Directive.import('package:copier/copier.dart'),
    ];

    final Library lib = Library((b) => b
      ..directives.addAll(imports)
      ..body.add(copier)
    );

    // Generate code and return
    final DartEmitter emitter = DartEmitter();
    final String generatedCode = '${lib.accept(emitter)}';
    return DartFormatter().format(generatedCode);
  }
}

Class generateCopier({
  String baseClassName,
  String newClassName,
  Map<String, String> fields
}) {
  List<Parameter> params = fields.entries
      .map((MapEntry<String, String> entry) => Parameter((b) => b
        ..name = entry.key
        ..type = refer(entry.value)
        ..named = true))
      .toList();

  String paramCode = fields.keys
      .map((String key) => '$key: $key')
      .toList()
      .join(', ');

  String detailedParamCode = fields.keys
      .map((String key) => 
        '$key : $key ?? master?.$key ?? defaultMaster.$key')
      .toList()
      .join(', ');

  String internalCopyCode = '''
      master = master ?? this.master;
      $baseClassName new$baseClassName = $baseClassName(
        $detailedParamCode
      );
      
      return resolve ? new$baseClassName : $newClassName(new$baseClassName);
    ''';

  final Method internalCopy = Method((b) => b
    ..name = 'internalCopy'
    ..returns = refer('dynamic')
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)))
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
      ..type = refer(baseClassName)))
    ..returns = refer(newClassName)
    ..body = Code('''
            return this.internalCopy(
              master,
              resolve: false,
            ) as $newClassName;
        '''));

  final Method copyAndResolve = Method((b) => b
    ..name = 'copyAndResolve'
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)))
    ..returns = refer(baseClassName)
    ..body = Code('''
          return this.internalCopy(
            master,
            resolve: true,
          ) as $baseClassName;
        '''));

  final Method copyWith = Method((b) => b
    ..name = 'copyWith'
    ..optionalParameters.addAll(params)
    ..returns = refer(newClassName)
    ..body = Code('''
            return this.internalCopy(
              this.master,
              resolve: false,
              $paramCode
            ) as $newClassName;
        '''));

  final Method copyWithAndResolve = Method((b) => b
    ..name = 'copyWithAndResolve'
    ..optionalParameters.addAll(params)
    ..returns = refer(baseClassName)
    ..body = Code('''
            return this.internalCopy(
              this.master,
              resolve: true,
              $paramCode
            ) as $baseClassName;
        '''));

  final Method resolve = Method((b) => b
    ..name = 'resolve'
    ..returns = refer(baseClassName)
    ..body = Code('return this.master;'));

  final Constructor constructor = Constructor((b) => b
    ..optionalParameters.add(
      Parameter((b) => b
        ..name = 'this.master'
      )
    )
  );

  final Field master = Field((b) => b
    ..name = 'master'
    ..type = refer(baseClassName)
  );

  final Method defaultMaster = Method((b) => b
    ..name = 'defaultMaster'
    ..returns = refer(baseClassName)
    ..type = MethodType.getter
    ..body = Code('''
        // TODO: Implement default
        return null;
      '''));

  final Class copier = Class((b) => b
    ..name = newClassName
    ..implements.add(refer('Copier<$baseClassName>'))
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

  return copier;
}

class SimpleFieldElementVisitor extends SimpleElementVisitor {
  Map<String, DartType> fields = {};

  @override
  visitFieldElement(FieldElement element) {
    this.fields[element.name] = element.type;
  }
}
