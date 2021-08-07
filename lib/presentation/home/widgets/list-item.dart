import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordInfo {
  late String word;
  int start = -1;
  late bool exact;
  int get end => start + word.length;
  bool get match => start > -1;
}

class SearchResultsListItem extends StatelessWidget {
  final String? verseTextTashkel;
  final String? verseText;
  final int? verseID;
  final double textSize;
  final double idSize;
  final Color? color;
  final Color? matchColor;
  final bool onlyIfExact;
  final String? keyword;

  SearchResultsListItem({
    this.keyword,
    this.verseTextTashkel,
    this.verseText,
    this.verseID,
    this.onlyIfExact = false,
    this.color,
    this.matchColor,
    this.textSize = 20,
    this.idSize = 28,
  });

  static List<WordInfo> findKeyword(
    String? keyword,
    String textEmla2y,
    String textTashkel,
  ) {
    //This approach depends on mapping the words across the Emla2y and Usmani text
    List<String> textEmla2yWords = textEmla2y.split(" ");
    List<String> textTashkelWords = textTashkel.split(" ");
    List<WordInfo> result = [];
    for (var i = 0; i < textTashkelWords.length; i++) {
      WordInfo info = WordInfo();
      String tashkelWord = textTashkelWords[i];
      info.word = tashkelWord;
      if (keyword?.isNotEmpty ?? false) {
        if (i < textEmla2yWords.length) {
          String emla2yWord = textEmla2yWords[i];
          info.start = emla2yWord.indexOf(keyword!);
          info.exact = (emla2yWord == keyword);
        }
      }
      result.add(info);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    String verseIdStr = ArabicNumbersService.insance.convert(this.verseID);
    List<WordInfo> infos = findKeyword(
      this.keyword,
      this.verseText!,
      this.verseTextTashkel!,
    );
    List<InlineSpan> verseSpans = infos.map((info) {
      Color? color = this.color;
      if (this.onlyIfExact) {
        if (info.exact) {
          color = this.matchColor;
        }
      } else {
        if (info.match) {
          color = this.matchColor;
        }
      }
      return TextSpan(
        text: "${info.word} ",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: this.textSize,
          fontFamily: "Usmani",
          color: color,
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
    return RichText(
      text: TextSpan(
        children: verseSpans,
      ),
    );
  }
}

//Approach 2
// //1- Prepare the indices
// String firstLetter = keyword[0];
// List<int> indices = Utils.findIndicesOfChar(textTashkel, firstLetter);
// //2- Loop through and get the findings
// int l = keyword.length;
// List<String> findings = [];
// for (var index in indices) {
//   String finding = Utils.substring(
//     text: textTashkel,
//     startFrom: index,
//     count: l,
//     countIf: Utils.arabicLetters(),
//   );
//   findings.add(finding);
// }
// print(findings);
// //3- Search for the exact finding in the original text
// String exactFinding = "";
// for (var finding in findings) {
//   String findingReduced = Utils.reduce(
//     text: finding,
//     countIf: Utils.arabicLetters(),
//   );
//   if (findingReduced == keyword) {
//     exactFinding = finding;
//     break;
//   }
// }

// //4- Get the index of the exact finding
// int start;
// int end;
// int i = textTashkel.indexOf(exactFinding);
// if (i > -1) {
//   start = i;
//   end = start + exactFinding.length + 1;
// }

// return [
//   textTashkel.substring(0, start),
//   textTashkel.substring(start, end),
//   textTashkel.substring(end),
// ];

//Approach 1
// int b = text.indexOf(keyword);
// int k = keyword.length;
// List<String> arr = [
//   text.substring(0, b),
//   text.substring(b, b + k),
//   text.substring(b + k),
// ];
// return arr;
