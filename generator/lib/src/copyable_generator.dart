import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:dart_style/dart_style.dart';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/emitter.dart';
import 'package:source_gen/source_gen.dart';

import 'package:copyable_generator/annotations.dart';

// Local, copyable
class LocalCopyableGenerator extends GeneratorForAnnotation<GenerateCopyable> {
  @override
  String generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep) {
    // Only classes can be annotated.
    if (element is ClassElement) {
      return this.generateForAnnotatedClassElement(element, annotation,
          buildStep);
    }

    return null;
  }

  String generateForAnnotatedClassElement(ClassElement element,
      ConstantReader annotation, BuildStep buildStep) {
    // Properties needed to implement Copyable
    String className = element.name;
    SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
    element.visitChildren(visitor);

    List<Parameter> fieldParams = visitor.fields;
    String forwardParameters = visitor.fields
        .map((Parameter p) => '${p.name}: ${p.name}')
        .toList()
        .join(',\n');
    
    // Define Copyable implementation methods.
    final Method copy = Method((b) => b
      ..name = 'copy'
      ..returns = refer(className)
      ..body = Code('''
        return _copy(this);
      ''')
    );

    final Method copyWith = Method((b) => b
      ..name = 'copyWith'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(className)
      ))
      ..returns = refer(className)
      ..body = Code('''
        return _copy(master);
      ''')
    );

    final Method copyWithProperties = Method((b) => b
      ..name = 'copyWithProperties'
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(className)
      ..body = Code('''
        return _copy(this, $forwardParameters);
      ''')
    );

    // Define core copy method.
    final Method _copy = Method((b) => b
      ..name = '_copy'
      ..requiredParameters.add(
        Parameter((b) => b
          ..name = 'master'
          ..type = refer(className)
        ),
      )
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(className)
      ..static = true
      ..body =  Code('''
        return $className(${visitor.fields
            .map((Parameter p) =>
              '${p.name} : ${p.name} ?? master?.${p.name}'
            )
            .toList()
            .join(', ')
        });
      ''')
    );

    // Define Copyable mixin.
    final Class copyableMixin = Class((b) => b
      ..name = 'Copyable' + className
      ..methods.addAll([
        copy,
        copyWith,
        copyWithProperties,
        _copy
      ])
    );

    // Generate code and return
    return specToString(copyableMixin);
  }
}

// Foreign, copyable
class ForeignCopyableGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    List<VariableElement> metas = [];

    // Find all CopyableMeta instances.
    library.allElements.forEach((Element e) {
      if (e is VariableElement) {
        if (e.type.name == 'CopyableMeta') {
          metas.add(e);
          return;
        }
      }
    });

    // For each CopyableMeta, generate a Copyable class; then combine them all.
    return metas.map((VariableElement meta) => this.generateFromVariableElement
      (meta)).toList().join('\n\n');
  }

  String generateFromVariableElement(VariableElement e) {
    // (super) field is where DartObject stores fields of superclass (i.e.
    // _CopyMeta)
    DartObject meta = e.computeConstantValue().getField('(super)');

    // Properties needed to generate Copyable.
    String import = meta.getField('import').toStringValue();
    String baseClassName = meta.getField('baseClass').toTypeValue().name;
    String newClassName = meta.getField('newClassName')?.toStringValue() ?? ''
        'Copyable' + baseClassName;
    Map<String, String> fields = meta
        .getField('fields')
        .toMapValue()
        .map(
            (DartObject key, DartObject value) =>
                MapEntry(
                    key.toStringValue(),
                    value.toTypeValue().name
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

    // Various code blocks
    String paramCode = fieldParams.map((Parameter p) => '${p.name} : ${p
        .name}').toList().join(', ');

    String detailedParamCode = fieldParams
        .map((Parameter p) =>
    '${p.name} : ${p.name} ??'
        ' master?.${p.name}')
        .toList()
        .join(', ');

    Code _copyCode = Code('''
      master = master ?? this.master;
      $baseClassName new$baseClassName = $baseClassName(
        $detailedParamCode
      );
      
      return $newClassName.from(new$baseClassName);
    ''');

    // Define Copyable implementation methods.
    final Method copy = Method((b) => b
      ..name = 'copy'
      ..returns = refer(newClassName)
      ..body = Code('''
        return this._copy(this.master);
      ''')
      ..annotations.add(refer('override'))
    );

    final Method copyWith = Method((b) => b
      ..name = 'copyWith'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'master'
        ..type = refer(baseClassName)
      ))
      ..returns = refer(newClassName)
      ..body = Code('''
        return this._copy(master);
      ''')
      ..annotations.add(refer('override'))
    );

    final Method copyWithProperties = Method((b) => b
      ..name = 'copyWithProperties'
      ..optionalParameters.addAll(fieldParams)
      ..returns = refer(newClassName)
      ..body = Code('''
        return this._copy(this.master, $paramCode);
      ''')
      ..annotations.add(refer('override'))
    );

    // Define main copy method.
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

    // Define fields and constructors.
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

    // Define class.
    final Class copyable = Class((b) => b
      ..name = newClassName
      ..constructors.addAll([
        propertyConstructor,
        fromExistingConstructor,
      ])
      ..fields.add(masterField)
      ..methods.addAll([
        copy,
        copyWith,
        copyWithProperties,
        _copy,
      ])
      ..extend = refer(baseClassName)
      ..implements.add(refer('Copyable<$baseClassName>'))
    );

    // Define library.
    final List<Directive> imports = [
      Directive.import(import),
      Directive.import('package:copier/copier.dart'),
    ];

    final Library lib = Library((b) => b
      ..directives.addAll(imports)
      ..body.add(copyable)
    );

    // Generate code and return
    return specToString(lib);
  }
}

// Local, copier
class LocalCopierGenerator extends GeneratorForAnnotation<GenerateCopier> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    // Only classes can be annotated.
    if (element is ClassElement) {
      return this.generateForAnnotatedClassElement(element, annotation, buildStep);
    }

    return null;
  }

  String generateForAnnotatedClassElement(
      ClassElement element, ConstantReader annotation, BuildStep buildStep) {
    // Visit class element to extract class fields.
    SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
    element.visitChildren(visitor);

    // Properties needed to generate copier.
    String baseClassName = element.name;
    String newClassName = baseClassName + 'Copier'; // TODO: Expose this option
    List<Parameter> fields = visitor.fields;
    String defaultObjectCode = annotation.read('defaultObjectCode').stringValue
        ?? '$baseClassName()';

    // Generate copier class.
    Class copier = generateCopierClass(
        baseClassName: baseClassName,
        newClassName: newClassName,
        fields: fields,
        defaultObjectCode: defaultObjectCode,
    );

    // Generate code from copier class and return.
    return specToString(copier);
  }
}

// Foreign, copier
class ForeignCopierGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    List<VariableElement> metas = [];

    // Find all CopierMeta instances.
    library.allElements.forEach((Element e) {
      if (e is VariableElement) {
        if (e.type.name == 'CopierMeta') {
          metas.add(e);
          return;
        }
      }
    });

    // For each CopierMeta, generate a Copier class; then combine them all.
    return metas.map((VariableElement meta) => this.generateFromVariableElement
      (meta)).toList().join('\n\n');
  }
  
  String generateFromVariableElement(VariableElement e) {
    // (super) field is where DartObject stores fields of superclass (i.e.
    // _CopyMeta)
    DartObject meta = e.computeConstantValue(); //

    // Properties needed to generate copier.
    DartObject superMeta = meta.getField('(super)');

    String import = superMeta.getField('import').toStringValue();
    String baseClassName = superMeta.getField('baseClass').toTypeValue().name;
    String newClassName = superMeta.getField('newClassName')?.toStringValue()
      ?? baseClassName + 'Copier';
    List<Parameter> fields = superMeta
        .getField('fields')
        .toMapValue()
        .entries
        .map(
            (MapEntry<DartObject, DartObject> entry) =>
            Parameter((b) => b
              ..name = entry.key.toStringValue()
              ..type = refer(entry.value.toTypeValue().name)
              ..named = true
            )
    ).toList();
    String defaultObjectCode = meta.getField('defaultObjectCode')
        .toStringValue() ?? '$baseClassName()';

    // Generate copier class.
    Class copier = generateCopierClass(
      baseClassName: baseClassName,
      newClassName: newClassName,
      fields: fields,
      defaultObjectCode: defaultObjectCode,
    );

    // Library needs to know of 'copier' package and package of class being
    // copied. TODO: Only works for one class / package. Fix this!
    final List<Directive> imports = [
      Directive.import(import),
      Directive.import('package:copier/copier.dart'),
    ];

    final Library lib = Library((b) => b
      ..directives.addAll(imports)
      ..body.add(copier)
    );

    // Generate code and return
    return specToString(lib);
  }
}

Class generateCopierClass({
  String baseClassName,
  String newClassName,
  List<Parameter> fields,
  String defaultObjectCode,
}) {
  // Convenience for forwarding parameters to another method.
  String forwardParameters = fields
      .map((Parameter p) => '${p.name}: ${p.name}')
      .toList()
      .join(', ');

  // Main copy method.
  final Method _copy = Method((b) => b
    ..name = '_copy'
    ..returns = refer('dynamic')
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)))
    ..optionalParameters.add(Parameter((b) => b
      ..name = 'resolve'
      ..type = refer('bool')
      ..named = true
      ..defaultTo = Code('false')))
    ..optionalParameters.addAll(fields)
    ..body = Code('''
      master = master ?? this.master;
      $baseClassName new$baseClassName = $baseClassName(
        ${fields.map((Parameter p) =>
          '${p.name} : ${p.name} ?? master?.${p.name} ?? defaultMaster.${p.name}')
        .toList()
        .join(', ')}
      );
      
      return resolve ? new$baseClassName : $newClassName(new$baseClassName);
    ''')
  );

  // Define Copier implementation methods.
  final Method copy = Method((b) => b
    ..name = 'copy'
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)))
    ..returns = refer(newClassName)
    ..body = Code('''
            return this._copy(
              master,
              resolve: false,
            ) as $newClassName;
        ''')
    ..annotations.add(refer('override'))
  );

  final Method copyAndResolve = Method((b) => b
    ..name = 'copyAndResolve'
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)))
    ..returns = refer(baseClassName)
    ..body = Code('''
          return this._copy(
            master,
            resolve: true,
          ) as $baseClassName;
        ''')
    ..annotations.add(refer('override'))
  );

  final Method copyWith = Method((b) => b
    ..name = 'copyWith'
    ..optionalParameters.addAll(fields)
    ..returns = refer(newClassName)
    ..body = Code('''
            return this._copy(
              this.master,
              resolve: false,
              $forwardParameters
            ) as $newClassName;
        ''')
    ..annotations.add(refer('override'))
  );

  final Method copyWithAndResolve = Method((b) => b
    ..name = 'copyWithAndResolve'
    ..optionalParameters.addAll(fields)
    ..returns = refer(baseClassName)
    ..body = Code('''
            return this._copy(
              this.master,
              resolve: true,
              $forwardParameters
            ) as $baseClassName;
        ''')
    ..annotations.add(refer('override'))
  );

  final Method resolve = Method((b) => b
    ..name = 'resolve'
    ..returns = refer(baseClassName)
    ..body = Code('return this.master;'));

  // Define fields and constructor.
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
      return $defaultObjectCode;
    '''));

  // Define copier class.
  final Class copier = Class((b) => b
    ..name = newClassName
    ..implements.add(refer('Copier<$baseClassName>'))
    ..fields.add(master)
    ..constructors.add(constructor)
    ..methods.addAll([
      defaultMaster,
      _copy,
      copy,
      copyAndResolve,
      copyWith,
      copyWithAndResolve,
      resolve,
    ]));

  return copier;
}

String specToString(Spec spec) {
  // Generate code and return
  final DartEmitter emitter = DartEmitter();
  final String generatedCode = '${spec.accept(emitter)}';
  return DartFormatter().format(generatedCode);
}

class SimpleFieldElementVisitor extends SimpleElementVisitor {
  List<Parameter> fields = [];

  @override
  visitFieldElement(FieldElement element) {
    this.fields.add(
      Parameter((b) => b
        ..name = element.name
        ..type = refer(element.type.name)
        ..named = true
      )
    );
  }
}
