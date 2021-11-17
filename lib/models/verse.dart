import 'package:yatadabaron/models/enums.dart';

import 'verse_slice.dart';


class Verse {
  final String? chapterName;
  final int chapterId;
  final String verseText;
  final String verseTextTashkel;
  final int verseID;

  Verse({
    required this.chapterId,
    this.chapterName,
    required this.verseText,
    required this.verseTextTashkel,
    required this.verseID,
  });

  List<VerseSlice> slice(String keyword, SearchMode mode) {
    return [
      VerseSlice(
        text: verseTextTashkel,
        matched: true,
      ),
    ];

    //This approach depends on mapping the words across the Emla2y and Usmani text
    // List<String> textEmla2yWords = textEmla2y.split(" ");
    // List<String> textTashkelWords = textTashkel.split(" ");
    // List<WordInfo> result = [];
    // for (var i = 0; i < textTashkelWords.length; i++) {
    //   WordInfo info = WordInfo();
    //   String tashkelWord = textTashkelWords[i];
    //   info.word = tashkelWord;
    //   if (keyword?.isNotEmpty ?? false) {
    //     if (i < textEmla2yWords.length) {
    //       String emla2yWord = textEmla2yWords[i];
    //       info.start = emla2yWord.indexOf(keyword!);
    //       info.exact = (emla2yWord == keyword);
    //     }
    //   }
    //   result.add(info);
    // }
    // return result;

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
  }

  int countKeyword(String keyword, SearchMode mode) {
    List<VerseSlice> slices = slice(keyword, mode);
    return slices.where((s) => s.matched).length;
  }
}
