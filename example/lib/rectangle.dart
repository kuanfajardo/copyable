import 'package:copier/copier.dart';
import 'package:copyable_generator/copyable_generator.dart';

part 'rectangle.g.dart';

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
