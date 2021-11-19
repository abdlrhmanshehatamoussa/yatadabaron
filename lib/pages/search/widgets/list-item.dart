import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';

class SearchResultsListItem extends StatelessWidget {
  final String verseId;
  final List<SearchSlice> slices;
  final Color? idColor;
  final Color? matchColor;

  SearchResultsListItem({
    required this.verseId,
    required this.slices,
    required this.matchColor,
    this.idColor,
  });

  @override
  Widget build(BuildContext context) {
    double textSize = 20;
    double idSize = 28;
    List<InlineSpan> verseSpans = slices.map((slice) {
      return TextSpan(
        text: slice.text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: textSize,
          color: slice.match ? matchColor : null,
        ),
      );
    }).toList();
    verseSpans.add(TextSpan(text: " "));
    verseSpans.add(TextSpan(
      text: this.verseId,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: idSize,
        fontFamily: "Usmani",
        color: idColor,
      ),
    ));
    return Text.rich(
      TextSpan(
        children: verseSpans,
      ),
    );
  }
}
