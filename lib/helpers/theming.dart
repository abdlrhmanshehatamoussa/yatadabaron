import 'package:flutter/material.dart';

class Theming {
  static ThemeData darkTheme() {
    Color accent = Color(0xfffff0cf);
    return ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: "Usmani"),
        accentColor: accent,
        floatingActionButtonTheme: ThemeData.dark()
            .floatingActionButtonTheme
            .copyWith(backgroundColor: accent),
        toggleableActiveColor: accent);
  }
}
