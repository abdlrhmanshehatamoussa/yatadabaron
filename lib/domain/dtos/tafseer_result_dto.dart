class TafseerResultDTO {
  final int verseId;
  final int chapterId;
  final int tafseerId;
  final String tafseerName;
  final String tafseerNameEnglish;
  final String chapterName;
  final String tafseerText;
  final String verseTextTashkeel;

  TafseerResultDTO({
    required this.verseTextTashkeel,
    required this.verseId,
    required this.chapterId,
    required this.tafseerId,
    required this.tafseerName,
    required this.tafseerNameEnglish,
    required this.chapterName,
    required this.tafseerText,
  });
}
