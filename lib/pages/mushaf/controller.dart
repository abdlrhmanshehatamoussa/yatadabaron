import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class MushafController extends BaseController {
  final IChaptersService chaptersService;
  final IVersesService versesService;
  final IUserDataService userDataService;
  final IAnalyticsService analyticsService;

  MushafController({
    required mushafLocation,
    required this.chaptersService,
    required this.versesService,
    required this.userDataService,
    required this.analyticsService,
  }) {
    reloadVerses(mushafLocation);
  }

  StreamObject<List<Verse>> _versesBloc = StreamObject();
  StreamObject<Chapter> _selectedChapterBloc = StreamObject();

  Stream<Chapter> get selectedChapterStream => _selectedChapterBloc.stream;
  Stream<List<Verse>> get versesStream => _versesBloc.stream;

  Future reloadVerses(MushafLocation? mushafLocation) async {
    if (mushafLocation == null) {
      //TODO: Try to Get the latest bookmarked mushaf location
    }
    mushafLocation ??= MushafLocation(
      chapterId: 1,
      verseId: 1,
    );
    int chapterId = mushafLocation.chapterId;
    int verseId = mushafLocation.verseId;
    Chapter chapter = await chaptersService.getChapter(chapterId);
    List<Verse> verses =
        await versesService.getVersesByChapterId(chapterId, false);

    _selectedChapterBloc.add(chapter);
    verses.firstWhere((v) => v.verseID == verseId).isSelected = true;
    _versesBloc.add(verses);
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
}
