// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ForeignCopyableLibraryGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:copyable/copyable.dart';

class CopyableBottomNavigationBar extends BottomNavigationBar
    implements Copyable<BottomNavigationBar> {
  CopyableBottomNavigationBar(
      {Color backgroundColor,
      double elevation,
      List<BottomNavigationBarItem> items})
      : this.master = BottomNavigationBar(
            backgroundColor: backgroundColor,
            elevation: elevation,
            items: items);

  CopyableBottomNavigationBar.from(BottomNavigationBar master)
      : this.master = master;

  final BottomNavigationBar master;

  @override
  CopyableBottomNavigationBar copy() {
    return this._copy(this.master);
  }

  @override
  CopyableBottomNavigationBar copyWith(BottomNavigationBar master) {
    return this._copy(master);
  }

  @override
  CopyableBottomNavigationBar copyWithProperties(
      {Color backgroundColor,
      double elevation,
      List<BottomNavigationBarItem> items}) {
    return this._copy(this.master,
        backgroundColor: backgroundColor, elevation: elevation, items: items);
  }

  CopyableBottomNavigationBar _copy(BottomNavigationBar master,
      {Color backgroundColor,
      double elevation,
      List<BottomNavigationBarItem> items}) {
    master = master ?? this.master;
    BottomNavigationBar newBottomNavigationBar = BottomNavigationBar(
        backgroundColor: backgroundColor, elevation: elevation, items: items);

    return CopyableBottomNavigationBar.from(newBottomNavigationBar);
  }
}
