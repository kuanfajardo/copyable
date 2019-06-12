import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/copyable_generator.dart';

Builder copierBuilder(BuilderOptions options) =>
    SharedPartBuilder([CopierGenerator()], 'copier');

Builder copyableBuilder(BuilderOptions options) =>
    LibraryBuilder(CopyableGenerator(), generatedExtension: '.copyable.dart');

Builder copyFunctionsBuilder(BuilderOptions options) =>
    SharedPartBuilder([CopyFunctionsGenerator()], 'functions');

Builder foreignCopierBuilder(BuilderOptions options) =>
    LibraryBuilder(ForeignCopierGenerator(), generatedExtension: '.copier'
        '.dart');