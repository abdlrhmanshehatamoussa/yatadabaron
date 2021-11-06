import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'view_models/mushaf_state.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class MushafBackend implements ISimpleBackend {
  MushafBackend({
    required this.chaptersService,
    required this.versesService,
    required this.bookmarksService,
    required this.analyticsService,
    required this.mushafSettings,
  }) {
    reloadVerses(mushafSettings);
  }

  final MushafSettings? mushafSettings;
  final IChaptersService chaptersService;
  final IVersesService versesService;
  final IBookmarksService bookmarksService;
  final IAnalyticsService analyticsService;

  StreamObject<MushafPageState> _stateStreamObj = StreamObject();
  Stream<MushafPageState> get stateStream => _stateStreamObj.stream;

  Future reloadVerses(MushafSettings? mushafSettings) async {
    if (mushafSettings == null) {
      Bookmark? lastBookmark = await bookmarksService.getLastBookmark();
      if (lastBookmark != null) {
        mushafSettings = MushafSettings.fromBookmark(
          chapterId: lastBookmark.chapterId,
          verseId: lastBookmark.verseId,
        );
      }

      if (mushafSettings == null) {
        mushafSettings = MushafSettings.fromSelection(
          chapterId: 1,
          verseId: 1,
        );
      }
    }
    int chapterId = mushafSettings.chapterId;
    int verseId = mushafSettings.verseId;
    Chapter chapter = await chaptersService.getChapter(chapterId);
    List<Verse> verses =
        await versesService.getVersesByChapterId(chapterId, false);
    List<Chapter> chapters =
        await chaptersService.getAll(includeWholeQuran: false);
    MushafPageState state = MushafPageState(
      chapter: chapter,
      verses: verses,
      startFromVerse: verseId,
      mode: mushafSettings.mode,
      chapters: chapters,
    );
    _stateStreamObj.add(state);
  }

  Future<void> logChapterSelected(String chatperNameAR, int chapterID) async {
    analyticsService.logOnTap(
      "CHAPTER SELECTED",
      payload: "NAME=$chatperNameAR|ID=$chapterID",
    );
  }

  Future<void> onChapterSelected(Chapter chapter) async {
    await logChapterSelected(
      chapter.chapterNameAR,
      chapter.chapterID,
    );

    await reloadVerses(
      MushafSettings.fromSelection(
        chapterId: chapter.chapterID,
        verseId: 1,
      ),
    );
  }
}
