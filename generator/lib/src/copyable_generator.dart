import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:dart_style/dart_style.dart';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/emitter.dart';
import 'package:source_gen/source_gen.dart';

import 'package:copyable_generator/annotations.dart';

class CopyableGenerator extends GeneratorForAnnotation<Copyable> {
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (!(element is ClassElement)) {
      // TODO !is, enable experiment
      return null;
    }

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

class SimpleFieldElementVisitor extends SimpleElementVisitor {
  Map<String, DartType> fields = {};

  @override
  visitFieldElement(FieldElement element) {
    this.fields[element.name] = element.type;
  }
}
