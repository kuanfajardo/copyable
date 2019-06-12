import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/copyable_generator.dart';

Builder localCopyableBuilder(BuilderOptions options) =>
    SharedPartBuilder([LocalCopyableGenerator()], 'copyable');

Builder foreignCopyableLibraryBuilder(BuilderOptions options) =>
    LibraryBuilder(ForeignCopyableGenerator(), generatedExtension: '.copyable.dart');

Builder localCopierBuilder(BuilderOptions options) =>
    SharedPartBuilder([LocalCopierGenerator()], 'copier');

Builder foreignCopierLibraryBuilder(BuilderOptions options) =>
    LibraryBuilder(ForeignCopierGenerator(), generatedExtension: '.copier'
        '.dart');