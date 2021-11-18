import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/search/view_models/colorized_span.dart';

class SearchResultsListItem extends StatelessWidget {
  final int verseId;
  final List<ColorizedSpan> spans;
  final Color? idColor;

  SearchResultsListItem({
    required this.verseId,
    required this.spans,
    this.idColor,
  });

  @override
  Widget build(BuildContext context) {
    double textSize = 20;
    double idSize = 28;
    String verseIdStr = Utils.convertToArabiNumber(this.verseId);
    List<InlineSpan> verseSpans = spans.map((span) {
      return TextSpan(
        text: span.text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: textSize,
          color: span.color,
        ),
      );
    }).toList();
    verseSpans.add(TextSpan(text: " "));
    verseSpans.add(TextSpan(
      text: "$verseIdStr",
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
