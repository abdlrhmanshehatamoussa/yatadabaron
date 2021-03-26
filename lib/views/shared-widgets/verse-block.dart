import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerseBlock extends StatelessWidget {
  final String verseText;
  final int verseID;
  final double textSize;
  final double idSize;
  final Color color;

  VerseBlock({
    this.verseText,
    this.verseID,
    this.color,
    this.textSize = 20,
    this.idSize = 28,
  });
  @override
  Widget build(BuildContext context) {
    String verseIdStr = ArabicNumbersService.insance.convert(this.verseID);
    return RichText(
      text: TextSpan(
          text: "${this.verseText}",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: this.textSize,
            fontFamily: "Usmani",
            color: this.color
          ),
          children: [
            TextSpan(text: " "),
            TextSpan(
              text: "$verseIdStr",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: this.idSize,
                fontFamily: "Usmani",
                color: this.color
              ),
            )
          ]),
    );
  }
}
