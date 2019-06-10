import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/copyable_generator.dart';

Builder copierBuilder(BuilderOptions options) =>
    SharedPartBuilder([CopierGenerator()], 'copier');

Builder copyableBuilder(BuilderOptions options) =>
    SharedPartBuilder([CopyableGenerator()], 'copyable');