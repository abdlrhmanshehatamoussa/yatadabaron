import 'package:flutter/material.dart';
import 'package:yatadabaron/models/verse_match.dart';

class ColorizedSpan {
  final String text;
  final Color? color;

  ColorizedSpan({
    required this.text,
    required this.color,
  });

  static List<ColorizedSpan> splitVerse({
    required String verseText,
    required List<VerseMatch> matches,
    Color? normalColor,
    Color? matchColor,
  }) {
    return [];
  }
}
