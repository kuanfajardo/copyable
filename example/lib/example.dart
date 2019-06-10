import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'example.g.dart';

@copy_functions
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
  Point copyFrom(Point master) => _copy(master);

  @override
  Point copyWith({int x, int y, Point parent}) => _copy(null, x: x, y: y, parent: parent);

  Point _copy(Point master, {int x, int y, Point parent}) {
    return Point(x : x ?? master?.x, y : y ?? master?.y, parent : parent ?? master?.parent);
  }
}

const CopyMeta pointCopyMeta = CopyMeta(
  baseClass: 'Point',
  fields: {
    'x': 'int',
    'y': 'int',
    'parent': 'Point',
  }
);
