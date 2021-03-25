import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerseBlock extends StatelessWidget {
  final String verseTextTashkel;
  final String verseText;
  final int verseID;
  final double textSize;
  final double idSize;
  final Color color;
  final Color matchColor;
  final String keyword;

  VerseBlock({
    this.keyword,
    this.verseTextTashkel,
    this.verseText,
    this.verseID,
    this.color,
    this.matchColor,
    this.textSize = 20,
    this.idSize = 28,
  });

  List<String> findKeyword(String keyword, String text, String textTashkel) {
    /**
      // Q: What are the boundaries of the word "FOX" ?
      // A: 6,9

      // 0123456789
      // FI`FE'FO;X

      // 1- Prepare the indices of letter F
      // indices = [0,3,6]

      // 2- Loop on the indices and get the first 3 characters
      // findings = [FI`F,FE`F,FO;X]

      // 3- Loop on the findings and check which is exactly matching
      // exact = FO;X

      // 4- Get the indices
      // indices = [6,9]
     */

    int b = text.indexOf(keyword);
    int k = keyword.length;
    List<String> arr = [
      this.verseText.substring(0, b),
      this.verseText.substring(b, b + k),
      this.verseText.substring(b + k),
    ];
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    String verseIdStr = ArabicNumbersService.insance.convert(this.verseID);
    List<String> array = [
      this.verseTextTashkel,
      "",
      "",
    ];
    if (keyword?.isNotEmpty ?? false) {
      array = findKeyword(
        this.keyword,
        this.verseText,
        this.verseTextTashkel,
      );
    }
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: array[0],
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: this.textSize,
            fontFamily: "Usmani",
            color: this.color,
          ),
        ),
        TextSpan(
          text: array[1],
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: this.textSize,
            fontFamily: "Usmani",
            color: this.matchColor,
          ),
        ),
        TextSpan(
          text: array[2],
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: this.textSize,
            fontFamily: "Usmani",
            color: this.color,
          ),
        ),
        TextSpan(text: " "),
        TextSpan(
          text: "$verseIdStr",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: this.idSize,
            fontFamily: "Usmani",
            color: this.color,
          ),
        )
      ]),
    );
  }
}
