import 'package:Yatadabaron/presentation/shared-blocs.module.dart';
import 'package:flutter/material.dart';

class DrawerBloc {
  DrawerBloc(this._themeBloc);

  final ThemeBloc _themeBloc;

  Stream<bool> get DarkMode =>
      _themeBloc.stream.map((ThemeData themeData) => true);
}
