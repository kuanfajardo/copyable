import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/copyable_generator.dart';

Builder localCopyableBuilder(BuilderOptions options) =>
    SharedPartBuilder([LocalCopyableGenerator()], 'copyable');

Builder localCopierBuilder(BuilderOptions options) =>
    SharedPartBuilder([LocalCopierGenerator()], 'copier');

Builder foreignCopyableLibraryBuilder(BuilderOptions options) =>
    LibraryBuilder(ForeignCopyableLibraryGenerator(), generatedExtension: ''
        '.copyables.dart');

Builder foreignCopierLibraryBuilder(BuilderOptions options) =>
    LibraryBuilder(ForeignCopierLibraryGenerator(), generatedExtension: ''
        '.copiers.dart');