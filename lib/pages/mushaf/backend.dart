import 'package:flutter/cupertino.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:yatadabaron/simple/module.dart';
import 'view_models/mushaf_state.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class MushafBackend extends SimpleBackend {
  MushafBackend({
    required this.mushafSettings,
    required BuildContext context,
  }) : super(context) {
    reloadVerses(mushafSettings);
  }

  final MushafSettings? mushafSettings;
  late IChaptersService chaptersService = getService<IChaptersService>();
  late IVersesService versesService = getService<IVersesService>();
  late IBookmarksService bookmarksService = getService<IBookmarksService>();
  late IAnalyticsService analyticsService = getService<IAnalyticsService>();

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

  void goTafseerPage(Verse verse) {
    navigatePush(
      view: TafseerPage(
        location: MushafLocation(
          verseId: verse.verseID,
          chapterId: verse.chapterId,
        ),
      ),
    );
  }
}
