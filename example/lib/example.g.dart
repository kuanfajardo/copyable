// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CopierGenerator
// **************************************************************************

class CircleCopier implements Copier<Circle> {
  CircleCopier([this.master]);

  Circle master;

  Circle get defaultMaster {
    // TODO: Implement default
    return null;
  }

  dynamic internalCopy(Circle master,
      {bool resolve = false, int radius, int centerX, int centerY}) {
    master = master ?? this.master;
    Circle newCircle = Circle(
        radius: radius ?? master?.radius ?? defaultMaster.radius,
        centerX: centerX ?? master?.centerX ?? defaultMaster.centerX,
        centerY: centerY ?? master?.centerY ?? defaultMaster.centerY);

    return resolve ? newCircle : CircleCopier(newCircle);
  }

  CircleCopier copy(Circle master) {
    return this.internalCopy(
      master,
      resolve: false,
    ) as CircleCopier;
  }

  Circle copyAndResolve(Circle master) {
    return this.internalCopy(
      master,
      resolve: true,
    ) as Circle;
  }

  CircleCopier copyWith({int radius, int centerX, int centerY}) {
    return this.internalCopy(this.master,
        resolve: false,
        radius: radius,
        centerX: centerX,
        centerY: centerY) as CircleCopier;
  }

  Circle copyWithAndResolve({int radius, int centerX, int centerY}) {
    return this.internalCopy(this.master,
        resolve: true,
        radius: radius,
        centerX: centerX,
        centerY: centerY) as Circle;
  }

  Circle resolve() {
    return this.master;
  }
}

// **************************************************************************
// CopyFunctionsGenerator
// **************************************************************************

/*
    Copy/Paste these methods into your class! Make sure to remember to 
          @override
      Rectangle copy() => _copy(this);
    
      @override
      Rectangle copyFrom(Rectangle master) => _copy(master);
    
      @override
      Rectangle copyWith({
int length,
int width,
Rectangle parent}) => _copy(null,
length: length,
width: width,
parent: parent);
    
      Rectangle _copy(Rectangle master, {
int length,
int width,
Rectangle parent}) {
        return Rectangle(
length : length ?? master?.length, width : width ?? master?.width, parent : parent ?? master?.parent);
      }
    
    */
