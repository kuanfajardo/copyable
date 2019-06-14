// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copyable_example.dart';

// **************************************************************************
// LocalCopyableGenerator
// **************************************************************************

class CopyableRectangle {
  Rectangle copy() {
    return _copy(this);
  }

  Rectangle copyWith(Rectangle master) {
    return _copy(master);
  }

  Rectangle copyWithProperties({int length, int width, Rectangle parent}) {
    return _copy(this, length: length, width: width, parent: parent);
  }

  static Rectangle _copy(Rectangle master,
      {int length, int width, Rectangle parent}) {
    return Rectangle(
        length: length ?? master?.length,
        width: width ?? master?.width,
        parent: parent ?? master?.parent);
  }
}
