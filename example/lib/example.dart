import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'example.g.dart';

/// Naive implementation of Copyable
class Point implements Copyable<Point> {
  final int x;
  final int y;
  Point parent;

  Point({
    this.x,
    this.y,
    this.parent
  });

  @override
  Point copy() => _copy(this);

  @override
  Point copyWith({
    int x,
    int y, 
    Point parent
  }) => _copy(null, 
      x: x, 
      y: y, 
      parent: parent
  );

  Point _copy(Point master, {
    int x, 
    int y, 
    Point parent
  }) {
    return Point(
        x : x ?? master?.x, 
        y : y ?? master?.y, 
        parent : parent ?? master?.parent
    );
  }
}

/// Use generator to write copy code for you! Just add the @copy_functions
/// annotation to your class. Don't forget to add `implements
/// Copyable<{className}>`
@copy_functions
class Rectangle implements Copyable<Rectangle> {
  final int length;
  final int width;
  Rectangle parent;

  Rectangle({
    this.length,
    this.width,
    this.parent
  });

  // Paste code from example.g.dart here:
}

/// Use the @build_copier annotation to generate a Copier for your class.
@build_copier
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
/// widgets), create a CopyMeta object describing the object. The generator
/// will then create a Copyable version of that object.
const CopierMeta appBarCopierMeta = CopierMeta(
  import: 'package:flutter/material.dart',
  baseClassName: 'AppBar',
  fields: {
    'title': 'Widget',
    'elevation': 'double',
    'primary': 'bool',
  }
);

const CopyableMeta appBarCopyableMeta = CopyableMeta(
  import: 'package:flutter/material.dart',
  baseClassName: 'AppBar',
  fields: {
    'title': 'Widget',
    'elevation': 'double',
    'primary': 'bool',
  },
);
