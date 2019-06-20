import 'package:copier/copier.dart';

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
