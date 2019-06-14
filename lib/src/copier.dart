import 'package:meta/meta.dart';

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

/// An interface for giving copy capabilities to classes whose implementation
/// is not editable (i.e. Flutter widgets). See [builtins](builtins.dart) for
/// examples on how to implement. TODO: Add documentation on generation.
// TODO: add copyWith and copyWithProperties
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
