class TafseerResultDTO {
  final int verseId;
  final int chapterId;
  final int tafseerId;
  final String tafseerName;
  final String chapterName;
  final String tafseer;
  final String verseTextTashkeel;

  TafseerResultDTO({
    required this.verseTextTashkeel,
    required this.verseId,
    required this.chapterId,
    required this.tafseerId,
    required this.tafseerName,
    required this.chapterName,
    required this.tafseer,
  });
}
