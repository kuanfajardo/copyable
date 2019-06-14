// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ForeignCopyableLibraryGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:copier/copier.dart';

class CopyableAppBar extends AppBar implements Copyable<AppBar> {
  CopyableAppBar({Widget title, double elevation, bool primary})
      : this.master =
            AppBar(title: title, elevation: elevation, primary: primary);

  CopyableAppBar.from(AppBar master) : this.master = master;

  final AppBar master;

  @override
  CopyableAppBar copy() {
    return this._copy(this.master);
  }

  @override
  CopyableAppBar copyWith(AppBar master) {
    return this._copy(master);
  }

  @override
  CopyableAppBar copyWithProperties(
      {Widget title, double elevation, bool primary}) {
    return this._copy(this.master,
        title: title, elevation: elevation, primary: primary);
  }

  CopyableAppBar _copy(AppBar master,
      {Widget title, double elevation, bool primary}) {
    master = master ?? this.master;
    AppBar newAppBar =
        AppBar(title: title, elevation: elevation, primary: primary);

    return CopyableAppBar.from(newAppBar);
  }
}
