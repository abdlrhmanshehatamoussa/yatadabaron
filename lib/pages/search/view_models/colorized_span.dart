import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';

class ColorizedSpan {
  final String text;
  final Color? color;

  ColorizedSpan({
    required this.text,
    required this.color,
  });

  static List<ColorizedSpan> splitVerse({
    required VerseSearchResult result,
    Color? normalColor,
    Color? matchColor,
  }) {
    //TODO:
    return [];
  }
}
