// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle.dart';

// **************************************************************************
// LocalCopierGenerator
// **************************************************************************

class CircleCopier implements Copier<Circle> {
  CircleCopier([this.master]);

  Circle master;

  Circle get defaultMaster {
    return Circle(radius: 1);
  }

  dynamic _copy(Circle master,
      {bool resolve = false, int radius, int centerX, int centerY}) {
    master = master ?? this.master;
    Circle newCircle = Circle(
        radius: radius ?? master?.radius ?? defaultMaster.radius,
        centerX: centerX ?? master?.centerX ?? defaultMaster.centerX,
        centerY: centerY ?? master?.centerY ?? defaultMaster.centerY);

    return resolve ? newCircle : CircleCopier(newCircle);
  }

  @override
  CircleCopier copy(Circle master) {
    return this._copy(
      master,
      resolve: false,
    ) as CircleCopier;
  }

  @override
  Circle copyAndResolve(Circle master) {
    return this._copy(
      master,
      resolve: true,
    ) as Circle;
  }

  @override
  CircleCopier copyWith({int radius, int centerX, int centerY}) {
    return this._copy(this.master,
        resolve: false,
        radius: radius,
        centerX: centerX,
        centerY: centerY) as CircleCopier;
  }

  @override
  Circle copyWithAndResolve({int radius, int centerX, int centerY}) {
    return this._copy(this.master,
        resolve: true,
        radius: radius,
        centerX: centerX,
        centerY: centerY) as Circle;
  }

  Circle resolve() {
    return this.master;
  }
}
