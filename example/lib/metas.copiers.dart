// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ForeignCopierLibraryGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:copyable/copyable.dart';

class AppBarCopier implements Copier<AppBar> {
  AppBarCopier([this.master]);

  AppBar master;

  AppBar get defaultMaster {
    return AppBar();
  }

  dynamic _copy(AppBar master,
      {bool resolve = false, Widget title, double elevation, bool primary}) {
    master = master ?? this.master;
    AppBar newAppBar = AppBar(
        title: title ?? master?.title ?? defaultMaster.title,
        elevation: elevation ?? master?.elevation ?? defaultMaster.elevation,
        primary: primary ?? master?.primary ?? defaultMaster.primary);

    return resolve ? newAppBar : AppBarCopier(newAppBar);
  }

  @override
  AppBarCopier copy(AppBar master) {
    return this._copy(
      master,
      resolve: false,
    ) as AppBarCopier;
  }

  @override
  AppBar copyAndResolve(AppBar master) {
    return this._copy(
      master,
      resolve: true,
    ) as AppBar;
  }

  @override
  AppBarCopier copyWith({Widget title, double elevation, bool primary}) {
    return this._copy(this.master,
        resolve: false,
        title: title,
        elevation: elevation,
        primary: primary) as AppBarCopier;
  }

  @override
  AppBar copyWithAndResolve({Widget title, double elevation, bool primary}) {
    return this._copy(this.master,
        resolve: true,
        title: title,
        elevation: elevation,
        primary: primary) as AppBar;
  }

  AppBar resolve() {
    return this.master;
  }
}
