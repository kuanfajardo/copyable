import 'package:copier/copier.dart';
import 'package:copyable_generator/annotations.dart';

part 'example.g.dart';

@Copyable()
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
