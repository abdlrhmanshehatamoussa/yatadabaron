import 'package:flutter/material.dart';

enum AppTheme { DARK, LIGHT }

class ThemeDataWrapper {
  final ThemeData themeData;
  final AppTheme appTheme;

  ThemeDataWrapper(this.themeData, this.appTheme);
}
