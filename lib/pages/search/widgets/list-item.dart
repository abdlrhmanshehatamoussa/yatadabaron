import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';

class SearchResultsListItem extends StatelessWidget {
  final int verseId;
  final List<VerseSlice> slices;
  final double textSize;
  final double idSize;
  final Color? color;
  final Color? matchColor;

  SearchResultsListItem({
    required this.verseId,
    required this.slices,
    this.color,
    this.matchColor,
    this.textSize = 20,
    this.idSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    String verseIdStr = Utils.convertToArabiNumber(this.verseId);
    List<InlineSpan> verseSpans = slices.map((info) {
      return TextSpan(
        text: info.text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: this.textSize,
          fontFamily: "Usmani",
          color: info.matched ? matchColor : color,
        ),
      );
    }).toList();
    verseSpans.add(TextSpan(text: " "));
    verseSpans.add(TextSpan(
      text: "$verseIdStr",
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: this.idSize,
        fontFamily: "Usmani",
        color: this.color,
      ),
    ));
    return Text.rich(
      TextSpan(
        children: verseSpans,
      ),
    );
  }
}