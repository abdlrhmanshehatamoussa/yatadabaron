import 'package:yatadabaron/global.dart';

class Verse {
  String? chapterName;
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

  @override
  String toString() {
    return "{$verseTextTashkel} [$chapterName:${verseID.toArabicNumber()}]";
  }
}
