import 'package:meta/meta.dart';

abstract class Copier<T> {
  @required T master;
  @required T get defaultMaster;

  // Main Method
  @required dynamic internalCopy(T master, {bool resolve = false});

  // Convenience
  @required Copier<T> copy(T master);
  @required T copyAndResolve(T master);

  @required Copier<T> copyWith(/* {{ Properties here! }} */);
  @required T copyWithAndResolve(/* {{ Properties here! }} */);

  @required T resolve();
}