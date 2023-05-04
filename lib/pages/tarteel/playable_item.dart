class TarteelPlayableItem {
  final String verseText;
  final int verseId;
  final int order;
  final String chapterName;
  final int chapterId;
  final String audioUrl;

  TarteelPlayableItem({
    required this.chapterId,
    required this.order,
    required this.verseText,
    required this.verseId,
    required this.chapterName,
    required this.audioUrl,
  });
}
