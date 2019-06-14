import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

import 'package:flutter/material.dart';

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
  Point copyWith(Point master) => _copy(master);

  @override
  Point copyWithProperties({
    int x,
    int y,
    Point parent
  }) => _copy(this,
      x: x,
      y: y,
      parent: parent
  );

  static Point _copy(Point master, {
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

/// Use the @generate_copyable annotation to generate a mixin named
/// `Copyable$className with the implementation methods of the Copyable
/// interface (so you don't have to!). The output will be in $fileName.g
/// .dart, so don't forget to add
/// ```
/// part '$fileName.g.dart'
/// ```
/// to the top of the file.
///
/// Additionally, you have to add the `with Copyable$className` and
/// `implements Copyable<$className>` modifiers to your class definition.
@generate_copyable
class Rectangle with CopyableRectangle implements Copyable<Rectangle> {
  final int length;
  final int width;
  Rectangle parent;

  Rectangle({
    this.length,
    this.width,
    this.parent
  });
}

/// For classes that are defined elsewhere (not editable, i.e. Flutter
/// widgets), define a CopyableMeta object describing the class that you want
/// to generate a Copyable version of for. These "foreign" copiers will end up
/// in $fileName.copyable.dart files.
const CopyableMeta appBarCopyableMeta = CopyableMeta(
  import: 'package:flutter/material.dart',
  baseClass: AppBar,
  fields: {
    'title': Widget,
    'elevation': double,
    'primary': bool,
  },
);
