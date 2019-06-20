import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:dart_style/dart_style.dart';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/emitter.dart';
import 'package:source_gen/source_gen.dart';

import 'package:copyable/src/generator/annotations.dart';

// Local, copyable (mixin)
class LocalCopyableGenerator extends GeneratorForAnnotation<GenerateCopyable> {
  @override
  String generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep) {
    // Only classes can be annotated.
    if (element is ClassElement) {
      SimpleFieldElementVisitor visitor = SimpleFieldElementVisitor();
      element.visitChildren(visitor);

      String baseClassName = element.name;
      List<Parameter> fields = visitor.fields;

      Class copyableMixin = generateCopyableMixin(baseClassName: baseClassName,
          fields:
      fields);

      return specToString(copyableMixin);
    }

    return null;
  }
}

// Local, copier (class)
class LocalCopierGenerator extends GeneratorForAnnotation<GenerateCopier> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    // Only classes can be annotated.
    if (element is ClassElement) {
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

    return null;
  }
}

// Foreign, copyable (lib)
class ForeignCopyableLibraryGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    VariableElement e;
    library.allElements.forEach((Element _e) {
      if (_e is VariableElement && _e.type.name == 'CopyMetaGenerator') {
        e = _e;
        return;
      }
    });

    DartObject metaGenerator = e.computeConstantValue();
    List<DartObject> copyableMetas = metaGenerator.getField('copyables')
        .toListValue(); // TODO: constant keys

    final List<Class> copyables = [];
    final List<Directive> imports = [];

    copyableMetas.forEach((DartObject copyableMeta) {
      DartObject copyableSuperMeta = copyableMeta.getField('(super)');

      String baseClassName = copyableSuperMeta.getField('baseClass')
          .toTypeValue().name;
      String newClassName = copyableSuperMeta.getField('newClassName')?.toStringValue()
          ?? 'Copyable' + baseClassName;
      List<Parameter> fields = copyableSuperMeta
          .getField('fields')
          .toMapValue()
          .entries
          .map(
              (MapEntry<DartObject, DartObject> entry) =>
              Parameter((b) => b
                ..name = entry.key.toStringValue()
                ..type = refer(entry.value.toStringValue())
                ..named = true
              )
      ).toList();

      Class copyable = generateCopyableClass(
        baseClassName: baseClassName,
        newClassName: newClassName,
        fields: fields,
      );

      copyables.add(copyable);

      //
      Directive import = Directive.import(
        // TODO: fail early if params not present
        copyableSuperMeta.getField('import').toStringValue()
      );
      imports.add(import);
    });

    imports.add(
        Directive.import('package:copyable/copyable.dart')
    );

    final Library copyableLib = Library((b) => b
      ..directives.addAll(imports)
      ..body.addAll(copyables)
    );

    return specToString(copyableLib);
  }
}

// Foreign, copier (lib)
class ForeignCopierLibraryGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    VariableElement e;
    library.allElements.forEach((Element _e) {
      if (_e is VariableElement && _e.type.name == 'CopyMetaGenerator') {
        e = _e;
        return;
      }
    });

    DartObject metaGenerator = e.computeConstantValue();
    List<DartObject> copierMetas = metaGenerator.getField('copiers')
        .toListValue(); // TODO: constant keys

    final List<Class> copiers = [];
    final List<Directive> imports = [];

    copierMetas.forEach((DartObject copierMeta) {
      DartObject copierSuperMeta = copierMeta.getField('(super)');

      String baseClassName = copierSuperMeta.getField('baseClass')
          .toTypeValue().name;
      String newClassName = copierSuperMeta.getField('newClassName')?.toStringValue()
          ?? baseClassName + 'Copier';
      List<Parameter> fields = copierSuperMeta
          .getField('fields')
          .toMapValue()
          .entries
          .map(
              (MapEntry<DartObject, DartObject> entry) =>
              Parameter((b) => b
                ..name = entry.key.toStringValue()
                ..type = refer(entry.value.toStringValue())
                ..named = true
              )
      ).toList();
      String defaultObjectCode = copierMeta.getField('defaultObjectCode')
          .toStringValue() ?? '$baseClassName()';

      Class copierClass = generateCopierClass(
        baseClassName: baseClassName,
        newClassName: newClassName,
        fields: fields,
        defaultObjectCode: defaultObjectCode,
      );

      copiers.add(copierClass);

      //
      Directive import = Directive.import(
        // TODO: fail early if params not present
        copierSuperMeta.getField('import').toStringValue()
      );
      imports.add(import);
    });

    imports.add(
        Directive.import('package:copyable/copyable.dart')
    );

    final Library copierLib = Library((b) => b
      ..directives.addAll(imports)
      ..body.addAll(copiers)
    );

    return specToString(copierLib);
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

Class generateCopyableClass({
  String baseClassName,
  String newClassName,
  List<Parameter> fields,
}) {
  String forwardParameters = fields
      .map((Parameter p) => '${p.name}: ${p.name}')
      .toList()
      .join(',\n');
  
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
    ..optionalParameters.addAll(fields)
    ..returns = refer(newClassName)
    ..body = Code('''
        return this._copy(this.master, $forwardParameters);
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
    ..optionalParameters.addAll(fields)
    ..returns = refer(newClassName)
    ..body = Code('''
      master = master ?? this.master;
      $baseClassName new$baseClassName = $baseClassName($forwardParameters);
      
      return $newClassName.from(new$baseClassName);
    ''')
  );

  // Define fields and constructors.
  final Field masterField = Field((b) => b
    ..name = 'master'
    ..type = refer(baseClassName)
    ..modifier = FieldModifier.final$
  );

  final Constructor propertyConstructor = Constructor((b) => b
    ..optionalParameters.addAll(fields)
    ..initializers.add(Code('''
        this.master = $baseClassName($forwardParameters)
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

  return copyable;
}

Class generateCopyableMixin({
  String baseClassName,
  List<Parameter> fields
}) {
  // Properties needed to implement Copyable
  String forwardParameters = fields
      .map((Parameter p) => '${p.name}: ${p.name}')
      .toList()
      .join(',\n');

  // Define Copyable implementation methods.
  final Method copy = Method((b) => b
    ..name = 'copy'
    ..returns = refer(baseClassName)
    ..body = Code('''
        return _copy(this);
      ''')
  );

  final Method copyWith = Method((b) => b
    ..name = 'copyWith'
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'master'
      ..type = refer(baseClassName)
    ))
    ..returns = refer(baseClassName)
    ..body = Code('''
        return _copy(master);
      ''')
  );

  final Method copyWithProperties = Method((b) => b
    ..name = 'copyWithProperties'
    ..optionalParameters.addAll(fields)
    ..returns = refer(baseClassName)
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
        ..type = refer(baseClassName)
      ),
    )
    ..optionalParameters.addAll(fields)
    ..returns = refer(baseClassName)
    ..static = true
    ..body =  Code('''
        return $baseClassName(${fields
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
    ..name = 'Copyable' + baseClassName
    ..methods.addAll([
      copy,
      copyWith,
      copyWithProperties,
      _copy
    ])
  );

  return copyableMixin;
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
