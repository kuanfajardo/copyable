# copyable

A package for giving copy capabilities to classes, both local (i.e. in
your source code), and foreign (i.e. defined in a third-party library).

#### Table of Contents
- [Setup](#setup)
- [Getting Started](#getting-started)
- [Copyable](#copyable-1)
  - [Interface](#interface)
  - [Implementation](#implementation)
  - [Code Generation](#code-generation)
- [Copier](#copier)
  - [Interface](#interface-1)
  - [Implementation](#implementation-1)
  - [Code Generation](#code-generation-1) 
- [Code Generation](#code-generation-2)
  - [Setup](#setup-1) 
  - [Usage](#usage)
 

### Setup

Add the following dependency to your `pubspec.yaml`

```yaml
dependencies:
  copyable: ^0.0.1
```

Using the code generation tools requires additional [setup](#setup-1).

### Getting Started
The `copyable` package defines two interfaces for giving copy-like
functionality to Dart classes: `Copyable` and `Copier`. 

Once you define a class that implements either of the two interfaces,
you can copy instances of the class like this:

**Copyable**
```dart
class Point implements Copyable<Point> {
  final int x;
  final int y;
  
  Point(this.x, this.y,);

  // Implement Copyable interface
}

Point origin = Point(0, 0);

// Copy
Point origin_copy = origin.copy();

// Copy, overriding some fields
Point x_intercept = origin.copyWithProperties(x: 5);
```

**Copier**
```dart
class PointCopier implements Copier<Point> {
  // Implement Copier interface
}

PointCopier pointCopier = PointCopier();
Point origin = Point(0, 0);

// Copy
Point origin_copy = pointCopier.copy(origin).resolve();

// Copy, overriding some fields
Point x_intercept = pointCopier.copyWith(x: 5).resolve();
```

Whether to use `Copyable` or `Copier` is a matter of preference: the
`Copyable` pattern adds copy functionality **directly** into a class,
where as the `Copier` pattern adds copy functionality **indirectly** by
creating an entirely new class.

## Copyable

#### Interface
```dart
/// An interface for copying objects.
abstract class Copyable<T> {
  /// Copy the current object.
  @required T copy();

  /// Copy the current object, overriding with non-null properties of
  /// `master` when present.
  @required T copyWith(T master);

  /// Copy the current object, overriding with the given properties.
  @required T copyWithProperties(/* Add named properties here; typically
  these are object fields.*/);
}
```

#### Implementation
```dart
import 'package:copyable/copyable.dart';

class Point implements Copyable<Point> {
  final int x;
  final int y;
  Point parent;

  Point({
    this.x,
    this.y,
    this.parent
  });

  // Copyable Implementation
  @override
  Point copy() => _copy(this);

  @override
  Point copyWith(Point master) => _copy(master);

  @override
  Point copyWithProperties({
    int x,
    int y,
    Point parent
  }) => _copy(this,
      x: x,
      y: y,
      parent: parent
  );

  static Point _copy(Point master, {
    int x,
    int y,
    Point parent
  }) {
    return Point(
        x : x ?? master?.x,
        y : y ?? master?.y,
        parent : parent ?? master?.parent
    );
  }
}
```

#### Code Generation
If you don't want to manually implement the `Copyable` interface (I
know, it's a lot of boilerplate :/ ), have no fear! Check out the
[code generation](#code-generation-2) section.

## Copier

#### Interface
```dart
abstract class Copier<T> {
  /// Necessary in order to support chaining of `copy()` calls.
  /// Basically a way to bootstrap a temporary master (from a previous `copy
  /// ()` call), it holds the result of the previous `.copy()` call so that
  /// the user doesn't have to re-wrap the result in a `Copier` instance.
  @required T master;

  /// The default template for copying. This will be the last
  /// fallback for any undefined properties of the object being copied.
  /// Typically just a bare-bones object (i.e. `T()`).
  @required T get defaultMaster;

  // Convenience Methods

  /// Copies the given object `master` and returns a new instance of `Copier<T>`
  /// whose master is the newly copied object.
  @required Copier<T> copy(T master);

  /// Copies the given object `master` and returns it.
  @required T copyAndResolve(T master);

  /// Copies `this.master` with the given parameters only. Returns a new
  /// instance of `Copier<T>` whose master is the newly copied object.
  /// **Note:** Concrete implementations of `Copier<T>` should add optional
  /// named parameters corresponding to the instance properties of `T`.
  @required Copier<T> copyWith(/* {{ Properties here! }} */);

  /// Copies `this.master` with the given parameters only. Returns the newly
  /// copied object.
  /// **Note:** Concrete implementations of `Copier<T>` should add optional
  /// named parameters corresponding to the instance properties of `T`.
  @required T copyWithAndResolve(/* {{ Properties here! }} */);

  /// Returns the result of the most recent copy (i.e. this.master).
  /// Literally the only code in this function should be `return this.master;`
  @required T resolve();
}
```

#### Implementation
```dart
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
```

#### Code Generation
If you don't want to manually implement the `Copier` interface (I know,
it's a lot of boilerplate :/ ), have no fear! Check out the
[code generation](#code-generation-2) section.

### Code Generation
Most of the code needed to implement either `Copyable` or `Copier` is
boilerplate and not fun. Instead, you can generate the respective
`Copyable` or `Copier` code using `build_runner`.

#### Setup
Add the following **dev** dependencies to your `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: ^1.0.0
  build_verify: ^1.1.0
```

If you don't already a `build.yaml` file, create one in your project
root directory (wherever `pubspec.yaml` is). Then, add the following to
your `build.yaml`:

```yaml
targets:
  $default:
    builders:
      # TODO: Add builders
```

###### Builders

There are four different builders you can use to generate copy-code.
Each builder corresponds to one of the four use cases described earlier
in [link here]:

| -           | Copyable             | Copier             |
|-------------|----------------------|--------------------|
|  **Local**  |           `copyable` |           `copier` |
| **Foreign** | `foreignCopyableLib` | `foreignCopierLib` |

Once you know which builder(s) you want to use, add them your
`build.yaml` with the pattern `copyable|{BUILDER_NAME}`:

```yaml
targets:
  $default:
    builders:
      copyable|copyable:
        generate_for:
          - lib/point.dart
      copyable|foreignCopyableLib:
        generate_for:
          - lib/circle.dart
      # More builders if needed...
```

#### Usage

0. Import `package:copyable/generator.dart`.

#### `copyable`
1. Annotate the class you want to generate copy code for with
   `@generate_copyable`.
2. Add
```dart
part '$FILE_NAME.g.dart';
```
to the top of your file.

3. Run the builder (see below). This will generate a **mixin** with the
   necessary copy-code as a `part of` file
4. Add the generated mixin to your original class.

#### `copier` 
1. Annotate the class you want to generate copy code for with
   `@GenerateCopier(defaultObjectCode: $DEFAULT)`. 
   
   In place of `$DEFAULT`, pass a string of the code to use to
   instantiate a "default" instance of the class; for example,
   
   ```dart
   @GenerateCopier(defaultObjectCode: 'Circle(radius: 1')   
   ```
   
2. Add
```dart
part '$FILE_NAME.g.dart';
```
to the top of your file.

3. Run the builder (see below). This will generate a **separate class**
   with the necessary copy-code as a `part of` file.

#### `foreignCopyableLib`

1. Create a `CopyableMeta` instance representing the class you want to
   generate a copyable version of for.
2. Create a `CopyMetaGenerator` instance and pass in the meta object.
3. Run the builder (see below). This will generate a separate
   **library** generated classes.
   
#### `foreignCopyableLib`

1. Create a `CopierMeta` instance representing the class you want to
   generate a copyable version of for.
2. Create a `CopyMetaGenerator` instance and pass in the meta object.
3. Run the builder (see below). This will generate a separate
   **library** generated classes.
