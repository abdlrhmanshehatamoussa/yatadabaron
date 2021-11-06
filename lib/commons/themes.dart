import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkTheme() {
    Color secondary = Colors.yellow;
    Color primary = Colors.white;

    ColorScheme colorScheme = ColorScheme.dark().copyWith(
      secondary: secondary,
      primary: primary,
    );

    return ThemeData.dark().copyWith(
      colorScheme: colorScheme,
      toggleableActiveColor: secondary,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light();
  }
}
