import 'package:flutter/material.dart';

enum AppTheme { DARK, LIGHT }

class ThemeDataWrapper {
  final ThemeData themeData;
  final AppTheme appTheme;

  ThemeDataWrapper(this.themeData, this.appTheme);

  static ThemeDataWrapper light() {
    return ThemeDataWrapper(_lightTheme(), AppTheme.LIGHT);
  }

  static ThemeDataWrapper dark() {
    return ThemeDataWrapper(_darkTheme(), AppTheme.DARK);
  }

  static ThemeData _darkTheme() {
    Color accent = Colors.yellow;

    ColorScheme colorScheme = ColorScheme.dark().copyWith(
      secondary: accent,
      primary: Colors.white,
    );

    TextTheme textTheme = ThemeData.dark().textTheme.apply(
      fontFamily: "Usmani",
    );

    return ThemeData.dark().copyWith(
      textTheme: textTheme,
      colorScheme: colorScheme,
      toggleableActiveColor: accent,
    );
  }

  static ThemeData _lightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(),
    );
  }
}
