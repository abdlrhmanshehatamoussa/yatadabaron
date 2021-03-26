class VerseDTO {
  final String chapterName;
  final String verseText;
  final String verseTextTashkel;
  final int verseID;
  final int chapterId;
  bool isSelected = false;
  bool isBookmark = false;

  VerseDTO(this.chapterId,this.chapterName, this.verseText,this.verseTextTashkel, this.verseID);
}
