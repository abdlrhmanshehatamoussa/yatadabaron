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
    Color secondary = Colors.yellow;
    Color primary = Colors.white;

    ColorScheme colorScheme = ColorScheme.dark().copyWith(
      secondary: secondary,
      primary: primary,
    );

    TextTheme textTheme = ThemeData.dark().textTheme.apply(
      fontFamily: "Usmani",
    );

    return ThemeData.dark().copyWith(
      textTheme: textTheme,
      colorScheme: colorScheme,
      toggleableActiveColor: secondary,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        color: Colors.black
      )
    );
  }

  static ThemeData _lightTheme() {
    return ThemeData.light();
  }
}
