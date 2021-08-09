import 'package:Yatadabaron/presentation/shared-blocs.module.dart';
import 'package:flutter/material.dart';

class ThemeBloc {
  final CustomStreamController<ThemeData> _themeBloc = CustomStreamController<ThemeData>();

  Stream<ThemeData> get stream => _themeBloc.stream;

  void updateTheme(ThemeData themeData) {
    _themeBloc.add(themeData);
  }
}
