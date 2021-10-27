import 'package:yatadabaron/viewmodels/module.dart';

enum MushafMode {
  BOOKMARK,
  SEARCH,
  SELECTION,
}

class MushafSettings {
  final MushafLocation location;
  final MushafMode mode;

  MushafSettings({
    required this.mode,
    required this.location,
  });

  static MushafSettings fromBookmark({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings(
      mode: MushafMode.BOOKMARK,
      location: MushafLocation(
        chapterId: chapterId,
        verseId: verseId,
      ),
    );
  }

  static MushafSettings fromSearch({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings(
      mode: MushafMode.SEARCH,
      location: MushafLocation(
        chapterId: chapterId,
        verseId: verseId,
      ),
    );
  }

  static MushafSettings fromSelection({
    required int chapterId,
    required int verseId,
  }) {
    return MushafSettings(
      mode: MushafMode.SELECTION,
      location: MushafLocation(
        chapterId: chapterId,
        verseId: verseId,
      ),
    );
  }
}
