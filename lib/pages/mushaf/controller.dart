import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'view_models/mushaf_state.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class MushafController extends BaseController {
  MushafController({
    required mushafSettings,
    required this.chaptersService,
    required this.versesService,
    required this.userDataService,
    required this.analyticsService,
  }) {
    reloadVerses(mushafSettings);
  }

  final IChaptersService chaptersService;
  final IVersesService versesService;
  final IUserDataService userDataService;
  final IAnalyticsService analyticsService;

  StreamObject<MushafPageState> _stateStreamObj = StreamObject();
  Stream<MushafPageState> get stateStream => _stateStreamObj.stream;

  Future reloadVerses(MushafSettings? mushafSettings) async {
    if (mushafSettings == null) {
      MushafLocation? lastLocation = await userDataService.getLastMushafLocation();
      if (lastLocation != null) {
        mushafSettings = MushafSettings.fromBookmark(
          chapterId: lastLocation.chapterId,
          verseId: lastLocation.verseId,
        );
      }

      if (mushafSettings == null) {
        mushafSettings = MushafSettings.fromSelection(
          chapterId: 1,
          verseId: 1,
        );
      }
    }
    int chapterId = mushafSettings.location.chapterId;
    int verseId = mushafSettings.location.verseId;
    Chapter chapter = await chaptersService.getChapter(chapterId);
    List<Verse> verses =
        await versesService.getVersesByChapterId(chapterId, false);

    MushafPageState state = MushafPageState(
      chapter: chapter,
      verses: verses,
      startFromVerse: verseId,
      mode: mushafSettings.mode,
    );
    _stateStreamObj.add(state);
  }

  Future<List<Chapter>> get getChaptersSimple async {
    List<Chapter> chapters =
        await chaptersService.getAll(includeWholeQuran: false);
    return chapters;
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
