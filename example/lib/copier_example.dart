import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'copier_example.g.dart';

/// Use the @generate_copier annotation to generate a Copier for your local
/// class. Local copiers will end up in $fileName.g.dart files.
@generate_copier
class Circle {
  final int radius;
  final int centerX;
  final int centerY;

  Circle({
    this.radius,
    this.centerX,
    this.centerY
  });
}

/// For classes that are defined elsewhere (not editable, i.e. Flutter
/// widgets), define a CopierMeta object describing the class that you want
/// to generate a copier for. These "foreign" copiers will end up in $fileName
/// .copier.dart files.
const CopierMeta appBarCopierMeta = CopierMeta(
    import: 'package:flutter/material.dart',
    baseClassName: 'AppBar',
    fields: {
      'title': 'Widget',
      'elevation': 'double',
      'primary': 'bool',
    }
);
