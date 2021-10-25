import 'package:flutter/material.dart';

enum AppTheme { DARK, LIGHT }

class ThemeDataWrapper {
  final ThemeData themeData;
  final AppTheme appTheme;

  ThemeDataWrapper({
    required this.themeData,
    required this.appTheme,
  });

  static ThemeDataWrapper light() {
    return ThemeDataWrapper(
      themeData: _lightTheme(),
      appTheme: AppTheme.LIGHT,
    );
  }

  static ThemeDataWrapper dark() {
    return ThemeDataWrapper(
      themeData: _darkTheme(),
      appTheme: AppTheme.DARK,
    );
  }

  static ThemeData _darkTheme() {
    Color secondary = Colors.yellow;
    Color primary = Colors.white;

    ColorScheme colorScheme = ColorScheme.dark().copyWith(
      secondary: secondary,
      primary: primary,
    );

    return ThemeData.dark().copyWith(
        colorScheme: colorScheme,
        toggleableActiveColor: secondary,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme:
            ThemeData.dark().appBarTheme.copyWith(color: Colors.black));
  }

  static ThemeData _lightTheme() {
    return ThemeData.light();
  }
}
