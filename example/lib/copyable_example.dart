import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'copyable_example.g.dart';

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

/// Use the @generate_copyable annotation to generate the code for
/// implementation methods of the Copyable interface (so you don't have to!).
/// The output will be in $fileName.g.dart, so don't forget to add
/// ```
/// part '$fileName.g.dart'
/// ```
/// to the top of the file.
///
/// Additionally, you have to manually copy/paste the generated code into the
/// annotated class. Don't forget to add `implements Copyable<$className>`.
@generate_copyable
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
  /*
  @override
  Rectangle copy() => _copy(this);

  @override
  Rectangle copyWith({
    int length,
    int width,
    Rectangle parent
  }) => _copy(null,
      length: length,
      width: width,
      parent: parent
  );

  Rectangle _copy(Rectangle master, {
    int length,
    int width,
    Rectangle parent
  }) {
    return Rectangle(
        length : length ?? master?.length,
        width : width ?? master?.width,
        parent : parent ?? master?.parent
    );
  }
  */
}

/// For classes that are defined elsewhere (not editable, i.e. Flutter
/// widgets), define a CopyableMeta object describing the class that you want
/// to generate a Copyable version of for. These "foreign" copiers will end up
/// in .copyable.dart files.
const CopyableMeta appBarCopyableMeta = CopyableMeta(
  import: 'package:flutter/material.dart',
  baseClassName: 'AppBar',
  fields: {
    'title': 'Widget',
    'elevation': 'double',
    'primary': 'bool',
  },
);
