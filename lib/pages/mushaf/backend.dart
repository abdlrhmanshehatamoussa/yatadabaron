import 'package:flutter/cupertino.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:simply/simply.dart';
import 'view_models/mushaf_state.dart';
import '../_viewmodels/module.dart';

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

  StreamObject<MushafPageState> _stateStreamObj = StreamObject();
  Stream<MushafPageState> get stateStream => _stateStreamObj.stream;
  StreamObject<bool> _showEmla2yStreamObj = StreamObject(initialValue: false);
  Stream<bool> get showEmla2yStream => _showEmla2yStreamObj.stream;

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
    List<Chapter> chapters = await chaptersService.getAll();
    MushafPageState state = MushafPageState(
      chapter: chapter,
      verses: verses,
      startFromVerse: verseId,
      mode: mushafSettings.mode,
      chapters: chapters,
    );
    _stateStreamObj.add(state);
  }

  Future<void> onChapterSelected(Chapter chapter) async {
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

  void updateShowEmla2y(bool v) {
    _showEmla2yStreamObj.add(v);
  }
}
