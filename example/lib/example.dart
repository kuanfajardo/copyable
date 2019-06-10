import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'example.g.dart';

@build_copier
class Point {
  final int x;
  final int y;
  Point parent;

  Point({
    this.x,
    this.y,
    this.parent
  });
}

const CopyMeta pointCopyMeta = CopyMeta(
  baseClass: 'Point',
  fields: {
    'x': 'int',
    'y': 'int',
    'parent': 'Point',
  }
);
