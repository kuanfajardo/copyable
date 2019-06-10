// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CopyableGenerator
// **************************************************************************

class PointCopier implements Copier<Point> {
  PointCopier([this.master]);

  Point master;

  Point get defaultMaster {
    // TODO: Implement default
    return null;
  }

  dynamic internalCopy(Point master,
      {bool resolve = false, int x, int y, Point parent}) {
    master = master ?? this.master;
    Point newPoint = Point(
        x: x ?? master?.x ?? defaultMaster.x,
        y: y ?? master?.y ?? defaultMaster.y,
        parent: parent ?? master?.parent ?? defaultMaster.parent);

    return resolve ? newPoint : PointCopier(newPoint);
  }

  PointCopier copy(Point master) {
    return this.internalCopy(
      master,
      resolve: false,
    ) as PointCopier;
  }

  Point copyAndResolve(Point master) {
    return this.internalCopy(
      master,
      resolve: true,
    ) as Point;
  }

  PointCopier copyWith({int x, int y, Point parent}) {
    return this.internalCopy(this.master,
        resolve: false, x: x, y: y, parent: parent) as PointCopier;
  }

  Point copyWithAndResolve({int x, int y, Point parent}) {
    return this.internalCopy(this.master,
        resolve: true, x: x, y: y, parent: parent) as Point;
  }

  Point resolve() {
    return this.master;
  }
}

// **************************************************************************
// NewClassGenerator
// **************************************************************************

class CopyablePoint extends Point implements Copyable<Point> {
  CopyablePoint({int x, int y, Point parent})
      : this.master = Point(x: x, y: y, parent: parent);

  CopyablePoint.from(Point master) : this.master = master;

  final Point master;

  CopyablePoint copy() {
    return this._copy(this.master);
  }

  CopyablePoint copyFrom(Point master) {
    return this._copy(master);
  }

  CopyablePoint copyWith({int x, int y, Point parent}) {
    return this._copy(null, x: x, y: y, parent: parent);
  }

  CopyablePoint _copy(Point master, {int x, int y, Point parent}) {
    Point newPoint = Point(
        x: x ?? master?.x, y: y ?? master?.y, parent: parent ?? master?.parent);

    return CopyablePoint.from(newPoint);
  }
}
