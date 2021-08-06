import 'package:Yatadabaron/repositories/userdata-repository.dart';

import '../blocs/generic-bloc.dart';
import '../dtos/chapter-full-dto.dart';
import '../dtos/chapter-simple-dto.dart';
import '../dtos/verse-dto.dart';
import '../repositories/chapters-repository.dart';
import '../repositories/verses-repository.dart';

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
}
