import 'package:meta/meta.dart';

/// An interface for giving copy capabilities to classes whose implementation
/// is not editable (i.e. Flutter widgets). See [builtins](builtins.dart) for
/// examples on how to implement. TODO: Add documentation on generation.
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

  /// Main copy method. See [builtins](builtins.dart) for examples
  /// on how to implement.
  @required dynamic internalCopy(T master, {bool resolve = false});

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
