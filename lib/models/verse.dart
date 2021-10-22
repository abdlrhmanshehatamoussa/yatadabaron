class Verse {
  //TODO: Variables shouldn't be nullable
  final String? chapterName;
  final String? verseText;
  final String? verseTextTashkel;
  final int? verseID;
  final int? chapterId;
  bool isSelected = false;
  bool isBookmark = false;

  Verse(this.chapterId,this.chapterName, this.verseText,this.verseTextTashkel, this.verseID);
}
