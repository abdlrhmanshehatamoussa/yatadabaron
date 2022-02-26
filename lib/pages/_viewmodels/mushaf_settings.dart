enum MushafMode {
  BOOKMARK,
  SEARCH,
  SELECTION,
}

class MushafSettings {
  final int chapterId;
  final int verseId;
  final MushafMode mode;

  MushafSettings._({
    required this.mode,
    required this.chapterId,
    required this.verseId,
  });

  static MushafSettings fromBookmark({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings._(
      mode: MushafMode.BOOKMARK,
      chapterId: chapterId,
      verseId: verseId,
    );
  }

  static MushafSettings fromSearch({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings._(
      mode: MushafMode.SEARCH,
      chapterId: chapterId,
      verseId: verseId,
    );
  }

  static MushafSettings fromSelection({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings._(
      mode: MushafMode.SELECTION,
      chapterId: chapterId,
      verseId: verseId,
    );
  }
}
