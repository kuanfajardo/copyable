import 'package:flutter/material.dart';

import 'package:copier/src/copier.dart';

// TODO: Copyables

// Default instances of copiers for convenience.
AppBarCopier appBarCopier = AppBarCopier();
BottomNavigationBarCopier bottomNavigationBarCopier =
    BottomNavigationBarCopier();
FloatingActionButtonCopier floatingActionButtonCopier =
    FloatingActionButtonCopier();

/// Copier for `AppBar`
class AppBarCopier implements Copier<AppBar> {
  @override
  AppBar master;

  AppBarCopier([this.master]);

  @override
  AppBar get defaultMaster => AppBar();

  @override
  dynamic internalCopy(AppBar master, {
    bool resolve: false,
    Widget leading,
    bool automaticallyImplyLeading,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary,
    bool centerTitle,
    double titleSpacing,
    double toolbarOpacity,
    double bottomOpacity,
  }) {
    master = master ?? this.master;
    AppBar newAppBar = AppBar(
      leading: leading ?? master?.leading ?? defaultMaster.leading,
      automaticallyImplyLeading: automaticallyImplyLeading ??
          master?.automaticallyImplyLeading ??
          defaultMaster.automaticallyImplyLeading,
      title: title ?? master?.title ?? defaultMaster.title,
      actions: actions ?? master?.actions ?? defaultMaster.actions,
      flexibleSpace: flexibleSpace ?? master?.flexibleSpace ?? defaultMaster
          .flexibleSpace,
      bottom: bottom ?? master?.bottom ?? defaultMaster.bottom,
      elevation: elevation ?? master?.elevation ?? defaultMaster.elevation,
      shape: shape ?? master?.shape ?? defaultMaster.shape,
      backgroundColor: backgroundColor ?? master?.backgroundColor ?? defaultMaster
          .backgroundColor,
      brightness: brightness ?? master?.brightness ?? defaultMaster.brightness,
      iconTheme: iconTheme ?? master?.iconTheme ?? defaultMaster.iconTheme,
      actionsIconTheme: actionsIconTheme ?? master?.actionsIconTheme ?? defaultMaster
          .actionsIconTheme,
      textTheme: textTheme ?? master?.textTheme ?? defaultMaster.textTheme,
      centerTitle: centerTitle ?? master?.centerTitle ?? defaultMaster.centerTitle,
      titleSpacing: titleSpacing ?? master?.titleSpacing ?? defaultMaster
          .titleSpacing,
      toolbarOpacity: toolbarOpacity ?? master?.toolbarOpacity ?? defaultMaster
          .toolbarOpacity,
      bottomOpacity: bottomOpacity ?? master?.bottomOpacity ?? defaultMaster
          .bottomOpacity,
    );

    return resolve ? newAppBar : AppBarCopier(newAppBar);
  }

  @override
  AppBarCopier copy(AppBar master) {
    return this.internalCopy(
      master,
      resolve: false,
    ) as AppBarCopier;
  }

  @override
  AppBar copyAndResolve(AppBar master) {
    return this.internalCopy(
      master,
      resolve: true,
    ) as AppBar;
  }

  @override
  AppBarCopier copyWith({
    Widget leading,
    bool automaticallyImplyLeading,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary,
    bool centerTitle,
    double titleSpacing,
    double toolbarOpacity,
    double bottomOpacity,
  }) {
    return this.internalCopy(
      this.master,
      resolve: false,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      shape: shape,
      backgroundColor: backgroundColor,
      brightness: brightness,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      textTheme: textTheme,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
    ) as AppBarCopier;
  }

  @override
  AppBar copyWithAndResolve({
    Widget leading,
    bool automaticallyImplyLeading,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary,
    bool centerTitle,
    double titleSpacing,
    double toolbarOpacity,
    double bottomOpacity,
  }) {
    return this.internalCopy(
      this.master,
      resolve: true,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      shape: shape,
      backgroundColor: backgroundColor,
      brightness: brightness,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      textTheme: textTheme,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
    ) as AppBar;
  }

  @override
  AppBar resolve() {
    return this.master;
  }
}

/// Copier for `BottomNavigationBar`
class BottomNavigationBarCopier implements Copier<BottomNavigationBar> {
  @override
  BottomNavigationBar master;

  BottomNavigationBarCopier([this.master]);

  @override
  BottomNavigationBar get defaultMaster => BottomNavigationBar(items: [
    BottomNavigationBarItem(icon: Icon(Icons.title), title: const Text
      ('Title')),
    BottomNavigationBarItem(icon: Icon(Icons.image), title: const Text
      ('Image')),
  ]);

  @override
  dynamic internalCopy(BottomNavigationBar master, {
    bool resolve: false,
    List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap,
    int currentIndex,
    double elevation,
    BottomNavigationBarType type,
    Color fixedColor,
    Color backgroundColor,
    double iconSize,
    Color selectedItemColor,
    Color unselectedItemColor,
    double selectedFontSize,
    double unselectedFontSize,
    bool showSelectedLabels,
    bool showUnselectedLabels,
  }) {
    BottomNavigationBar newBottomNavigationBar = BottomNavigationBar(
      items: items ?? master?.items ?? defaultMaster.items,
      onTap: onTap ?? master?.onTap ?? defaultMaster.onTap,
      currentIndex: currentIndex ?? master?.currentIndex ?? defaultMaster.currentIndex,
      elevation: elevation ?? master?.elevation ?? defaultMaster.elevation,
      type: type ?? master?.type ?? defaultMaster.type,
      fixedColor: fixedColor ?? master?.fixedColor ?? defaultMaster.fixedColor,
      backgroundColor: backgroundColor ?? master?.backgroundColor ?? defaultMaster.backgroundColor,
      iconSize: iconSize ?? master?.iconSize ?? defaultMaster.iconSize,
      selectedItemColor: selectedItemColor ?? master?.selectedItemColor ??
          defaultMaster.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? master?.unselectedItemColor
          ?? defaultMaster.unselectedItemColor,
      selectedFontSize: selectedFontSize ?? master?.selectedFontSize ?? defaultMaster
          .selectedFontSize,
      unselectedFontSize: unselectedFontSize ?? master?.unselectedFontSize ??
          defaultMaster.unselectedFontSize,
      showSelectedLabels: showSelectedLabels ?? master?.showSelectedLabels ??
          defaultMaster.showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels ?? master?.showUnselectedLabels
          ?? defaultMaster.showUnselectedLabels,
    );

    return resolve ? newBottomNavigationBar : BottomNavigationBarCopier
      (newBottomNavigationBar);
  }

  @override
  BottomNavigationBarCopier copy(BottomNavigationBar master) {
    return this.internalCopy(
      master,
      resolve: false,
    ) as BottomNavigationBarCopier;
  }

  @override
  BottomNavigationBar copyAndResolve(BottomNavigationBar master) {
    return this.internalCopy(
      master,
      resolve: true,
    ) as BottomNavigationBar;
  }

  @override
  BottomNavigationBarCopier copyWith({
    List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap,
    int currentIndex,
    double elevation,
    BottomNavigationBarType type,
    Color fixedColor,
    Color backgroundColor,
    double iconSize,
    Color selectedItemColor,
    Color unselectedItemColor,
    double selectedFontSize,
    double unselectedFontSize,
    bool showSelectedLabels,
    bool showUnselectedLabels,
  }) {
    return this.internalCopy(
      this.master,
      resolve: false,
      items: items,
      onTap: onTap,
      currentIndex: currentIndex,
      elevation: elevation,
      type: type,
      fixedColor: fixedColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
    ) as BottomNavigationBarCopier;
  }

  @override
  BottomNavigationBar copyWithAndResolve({
    List<BottomNavigationBarItem> items,
    ValueChanged<int> onTap,
    int currentIndex,
    double elevation,
    BottomNavigationBarType type,
    Color fixedColor,
    Color backgroundColor,
    double iconSize,
    Color selectedItemColor,
    Color unselectedItemColor,
    double selectedFontSize,
    double unselectedFontSize,
    bool showSelectedLabels,
    bool showUnselectedLabels,
  }) {
    return this.internalCopy(
      this.master,
      resolve: true,
      items: items,
      onTap: onTap,
      currentIndex: currentIndex,
      elevation: elevation,
      type: type,
      fixedColor: fixedColor,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
    ) as BottomNavigationBar;
  }

  @override
  BottomNavigationBar resolve() {
    return this.master;
  }
}

/// Copier for `FloatingActionButton`
class FloatingActionButtonCopier implements Copier<FloatingActionButton> {
  @override
  FloatingActionButton master;

  FloatingActionButtonCopier([this.master]);

  @override
  FloatingActionButton get defaultMaster => FloatingActionButton(onPressed: () => {});

  @override
  dynamic internalCopy(FloatingActionButton master, {
    bool resolve = false,
    Widget child,
    String tooltip,
    Color foregroundColor,
    Color backgroundColor,
    Object heroTag,
    double elevation,
    double highlightElevation,
    double disabledElevation,
    VoidCallback onPressed,
    bool mini,
    ShapeBorder shape,
    Clip clipBehavior,
    MaterialTapTargetSize materialTapTargetSize,
    bool isExtended,
  }) {
    FloatingActionButton newFloatingActionButton = FloatingActionButton(
      onPressed: onPressed ?? master?.onPressed ?? defaultMaster.onPressed,
      child: child ?? master?.child ?? defaultMaster.child,
      tooltip: tooltip ?? master?.tooltip ?? defaultMaster.tooltip,
      foregroundColor: foregroundColor ?? master?.foregroundColor ?? defaultMaster.foregroundColor,
      backgroundColor: backgroundColor ?? master?.backgroundColor ?? defaultMaster.backgroundColor,
      heroTag: heroTag ?? master?.heroTag ?? defaultMaster.heroTag,
      elevation: elevation ?? master?.elevation ?? defaultMaster.elevation,
      highlightElevation: highlightElevation ?? master?.highlightElevation ??
          defaultMaster.highlightElevation,
      disabledElevation: disabledElevation ?? master?.disabledElevation ??
          defaultMaster.disabledElevation,
      mini: mini ?? master?.mini ?? defaultMaster.mini,
      shape: shape ?? master?.shape ?? defaultMaster.shape,
      clipBehavior: clipBehavior ?? master?.clipBehavior ?? defaultMaster.clipBehavior,
      materialTapTargetSize: materialTapTargetSize ?? master?.materialTapTargetSize
          ?? defaultMaster.materialTapTargetSize,
      isExtended: isExtended ?? master?.isExtended ?? defaultMaster.isExtended,
    );

    return resolve ? newFloatingActionButton : FloatingActionButtonCopier
      (newFloatingActionButton);
  }

  @override
  FloatingActionButtonCopier copy(FloatingActionButton master) {
    return this.internalCopy(
        master,
        resolve: false
    ) as FloatingActionButtonCopier;
  }

  @override
  FloatingActionButton copyAndResolve(FloatingActionButton master) {
    return this.internalCopy(
        master,
        resolve: true
    ) as FloatingActionButton;
  }

  @override
  FloatingActionButtonCopier copyWith({
    Widget child,
    String tooltip,
    Color foregroundColor,
    Color backgroundColor,
    Object heroTag,
    double elevation,
    double highlightElevation,
    double disabledElevation,
    VoidCallback onPressed,
    bool mini,
    ShapeBorder shape,
    Clip clipBehavior,
    MaterialTapTargetSize materialTapTargetSize,
    bool isExtended,
  }) {
    return this.internalCopy(
      this.master,
      resolve: false,
      child: child,
      tooltip: tooltip,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      heroTag: heroTag,
      elevation: elevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      onPressed: onPressed,
      mini: mini,
      shape: shape,
      clipBehavior: clipBehavior,
      materialTapTargetSize: materialTapTargetSize,
      isExtended: isExtended,
    ) as FloatingActionButtonCopier;
  }

  @override
  FloatingActionButton copyWithAndResolve({
    Widget child,
    String tooltip,
    Color foregroundColor,
    Color backgroundColor,
    Object heroTag,
    double elevation,
    double highlightElevation,
    double disabledElevation,
    VoidCallback onPressed,
    bool mini,
    ShapeBorder shape,
    Clip clipBehavior,
    MaterialTapTargetSize materialTapTargetSize,
    bool isExtended,
  }) {
    return this.internalCopy(
      this.master,
      resolve: true,
      child: child,
      tooltip: tooltip,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      heroTag: heroTag,
      elevation: elevation,
      highlightElevation: highlightElevation,
      disabledElevation: disabledElevation,
      onPressed: onPressed,
      mini: mini,
      shape: shape,
      clipBehavior: clipBehavior,
      materialTapTargetSize: materialTapTargetSize,
      isExtended: isExtended,
    ) as FloatingActionButton;
  }

  @override
  FloatingActionButton resolve() {
    return this.master;
  }
}