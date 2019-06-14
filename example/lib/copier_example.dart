import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'copier_example.g.dart';

/// Use the @GenerateCopier annotation to generate a Copier for your local
/// class. It takes one parameter, `defaultObjectCode`, that is a String of
/// the code for instantiating a default object. If the default instantiation
/// has no parameters (i.e. `Circle()`), you can use the @generate_copier
/// annotation for convenience.
///
/// Local copiers will end up in $fileName.g.dart files.
@GenerateCopier(defaultObjectCode: 'Circle(radius: 1)')
class Circle {
  final int radius;
  final int centerX;
  final int centerY;

  Circle({
    this.radius,
    this.centerX,
    this.centerY
  }) : assert(radius > 0);
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
  },
  defaultObjectCode: 'AppBar()' // If not provided defaults to `$baseClassName()`
);
