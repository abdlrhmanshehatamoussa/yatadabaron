enum MushafMode {
  BOOKMARK,
  SEARCH,
  SELECTION,
}

class MushafSettings {
  final int chapterId;
  final int verseId;
  final MushafMode mode;

  MushafSettings({
    required this.chapterId,
    required this.verseId,
    required this.mode,
  });
}
