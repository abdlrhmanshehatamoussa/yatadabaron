import 'package:Yatadabaron/crosscutting/generic-bloc.dart';
import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/persistence.module.dart';

class MushafBloc {
  MushafBloc(int? chapterId, int? verseId) {
    reloadVerses(chapterId, verseId);
  }

  GenericBloc<List<VerseDTO>> _versesBloc = GenericBloc();
  GenericBloc<ChapterFullDTO> _selectedChapterBloc = GenericBloc();

  Stream<ChapterFullDTO> get selectedChapterStream =>
      _selectedChapterBloc.stream;
  Stream<List<VerseDTO>> get versesStream => _versesBloc.stream;
  Future saveBookmark(int chapterId, int verseId) async {
    await UserDataRepository.instance.setBookmarkChapter(chapterId);
    await UserDataRepository.instance.setBookmarkVerse(verseId);
    await reloadVerses(
      chapterId,
      verseId,
    );
  }

  Future reloadVerses(int? chapterId, int? verseId) async {
    chapterId = chapterId ?? 1;
    ChapterFullDTO chapter =
        await ChaptersRepository.instance.getFullChapterById(chapterId);
    List<VerseDTO> verses =
        await VersesRepository.instance.getVersesByChapterId(chapterId, false);

    _selectedChapterBloc.add(chapter);
    if (verseId != null && verseId > 0) {
      verses.firstWhere((v) => v.verseID == verseId).isSelected = true;
    }
    //Load the bookmarks
    int? bmC = await UserDataRepository.instance.getBookmarkChapter();
    if (bmC != null) {
      if (bmC == chapterId) {
        int? bmV = await UserDataRepository.instance.getBookmarkVerse();
        verses.firstWhere((v) => v.verseID == bmV).isBookmark = true;
      }
    }
    _versesBloc.add(verses);
  }

  Future<List<ChapterSimpleDTO>> get getChaptersSimple async {
    return await ChaptersRepository.instance.getChaptersSimple();
  }

  Future<void> logChapterSelected(String chatperNameAR, int chapterID) async {
    AnalyticsService.instance.logOnTap(
      "CHAPTER SELECTED",
      payload: "NAME=$chatperNameAR|ID=$chapterID",
    );
  }
}
