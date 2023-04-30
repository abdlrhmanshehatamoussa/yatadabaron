class TarteelPlayableItem {
  final String verseText;
  final int verseId;
  final int order;
  final String chapterName;
  final String audioUrl;

  TarteelPlayableItem({
    required this.order,
    required this.verseText,
    required this.verseId,
    required this.chapterName,
    required this.audioUrl,
  });
}
