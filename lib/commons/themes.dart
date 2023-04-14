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
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return secondary;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return secondary;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return secondary;
          }
          return null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return secondary;
          }
          return null;
        }),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light();
  }
}
