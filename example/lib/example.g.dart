// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CopyableGenerator
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

// **************************************************************************
// CopyFunctionsGenerator
// **************************************************************************

/*
      @override
      Point copy() => _copy(this);
    
      @override
      Point copyFrom(Point master) => _copy(master);
    
      @override
      Point copyWith({int x, int y, Point parent}) => _copy(null, x: x, y: y, parent: parent);
    
      @override
      Point _copy(Point master, {int x, int y, Point parent}) {
        return Point(x : x ?? master?.x, y : y ?? master?.y, parent : parent ?? master?.parent);
      }
    */
