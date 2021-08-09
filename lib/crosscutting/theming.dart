import 'package:flutter/material.dart';

class Theming {
  static ThemeData darkTheme() {
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
}
