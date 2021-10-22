import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';

class MushafController {
  final IChaptersService chaptersService;
  final IVersesService versesService;
  final IUserDataService userDataService;
  final IAnalyticsService analyticsService;
  final int? chapterId;
  final int? verseId;

  MushafController({
    required this.chapterId,
    required this.verseId,
    required this.chaptersService,
    required this.versesService,
    required this.userDataService,
    required this.analyticsService,
  }) {
    reloadVerses(chapterId, verseId);
  }

  StreamObject<List<Verse>> _versesBloc = StreamObject();
  StreamObject<Chapter> _selectedChapterBloc =
      StreamObject();

  Stream<Chapter> get selectedChapterStream => _selectedChapterBloc.stream;
  Stream<List<Verse>> get versesStream => _versesBloc.stream;

  Future reloadVerses(int? chapterId, int? verseId) async {
    chapterId = chapterId ?? 1;
    Chapter chapter = await chaptersService.getChapter(chapterId);
    List<Verse> verses =
        await versesService.getVersesByChapterId(chapterId, false);

    _selectedChapterBloc.add(chapter);
    if (verseId != null && verseId > 0) {
      verses.firstWhere((v) => v.verseID == verseId).isSelected = true;
    }
    //Load the bookmarks
    int? bmC = await userDataService.getBookmarkChapter();
    if (bmC != null) {
      if (bmC == chapterId) {
        int? bmV = await userDataService.getBookmarkVerse();
        verses.firstWhere((v) => v.verseID == bmV).isBookmark = true;
      }
    }
    _versesBloc.add(verses);
  }

  Future<List<Chapter>> get getChaptersSimple async {
    return await chaptersService.getAll(includeWholeQuran: false);
  }

  Future<void> logChapterSelected(String chatperNameAR, int chapterID) async {
    analyticsService.logOnTap(
      "CHAPTER SELECTED",
      payload: "NAME=$chatperNameAR|ID=$chapterID",
    );
  }
}
