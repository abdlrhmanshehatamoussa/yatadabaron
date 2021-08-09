import 'package:Yatadabaron/presentation/shared-blocs.module.dart';
import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';

class MushafBloc {
  MushafBloc(int? chapterId, int? verseId) {
    reloadVerses(chapterId, verseId);
  }

  CustomStreamController<List<VerseDTO>> _versesBloc = CustomStreamController();
  CustomStreamController<ChapterFullDTO> _selectedChapterBloc = CustomStreamController();

  Stream<ChapterFullDTO> get selectedChapterStream =>
      _selectedChapterBloc.stream;
  Stream<List<VerseDTO>> get versesStream => _versesBloc.stream;
  Future saveBookmark(int chapterId, int verseId) async {
    await ServiceManager.instance.userDataService.setBookmarkChapter(chapterId);
    await ServiceManager.instance.userDataService.setBookmarkVerse(verseId);
    await reloadVerses(
      chapterId,
      verseId,
    );
  }

  Future reloadVerses(int? chapterId, int? verseId) async {
    chapterId = chapterId ?? 1;
    ChapterFullDTO chapter =
        await ServiceManager.instance.mushafService.getFullChapterById(chapterId);
    List<VerseDTO> verses =
        await ServiceManager.instance.mushafService.getVersesByChapterId(chapterId, false);

    _selectedChapterBloc.add(chapter);
    if (verseId != null && verseId > 0) {
      verses.firstWhere((v) => v.verseID == verseId).isSelected = true;
    }
    //Load the bookmarks
    int? bmC = await ServiceManager.instance.userDataService.getBookmarkChapter();
    if (bmC != null) {
      if (bmC == chapterId) {
        int? bmV = await ServiceManager.instance.userDataService.getBookmarkVerse();
        verses.firstWhere((v) => v.verseID == bmV).isBookmark = true;
      }
    }
    _versesBloc.add(verses);
  }

  Future<List<ChapterSimpleDTO>> get getChaptersSimple async {
    return await ServiceManager.instance.mushafService.getMushafChapters();
  }

  Future<void> logChapterSelected(String chatperNameAR, int chapterID) async {
    ServiceManager.instance.analyticsService.logOnTap(
      "CHAPTER SELECTED",
      payload: "NAME=$chatperNameAR|ID=$chapterID",
    );
  }
}
