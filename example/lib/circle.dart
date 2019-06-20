import 'package:copyable/copyable.dart';
import 'package:copyable_generator/copyable_generator.dart';

part 'circle.g.dart';

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
