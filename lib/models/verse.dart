class Verse {
  final String? chapterName;
  final int? chapterId;
  final String verseText;
  final String verseTextTashkel;
  final int verseID;
  bool isSelected = false;

  Verse({
    this.chapterId,
    this.chapterName,
    required this.verseText,
    required this.verseTextTashkel,
    required this.verseID,
  });
}
