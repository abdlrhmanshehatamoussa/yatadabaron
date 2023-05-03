import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:yatadabaron/commons/utils.dart';

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

  String get verseTextTashkelWithNumber =>
      verseTextTashkel + " " + ArabicNumbers().convert(verseID.toString());

  @override
  String toString() {
    return "{$verseTextTashkel} ($chapterName:${Utils.convertToArabiNumber(verseID)})";
  }
}
