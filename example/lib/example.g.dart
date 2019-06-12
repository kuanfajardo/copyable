// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// LocalCopierGenerator
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
// LocalCopyableGenerator
// **************************************************************************

/*
    Copy/Paste these methods into your class! Make sure to remember to 
          @override
      Circle copy() => _copy(this);
    
      @override
      Circle copyFrom(Circle master) => _copy(master);
    
      @override
      Circle copyWith({
int radius,
int centerX,
int centerY}) => _copy(null,
radius: radius,
centerX: centerX,
centerY: centerY);
    
      Circle _copy(Circle master, {
int radius,
int centerX,
int centerY}) {
        return Circle(
radius : radius ?? master?.radius, centerX : centerX ?? master?.centerX, centerY : centerY ?? master?.centerY);
      }
    
    */
