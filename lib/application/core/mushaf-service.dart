import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class MushafService implements IMushafService {
  MushafService(
    this._chaptersRepository,
    this._versesRepository,
  );

  final ChaptersRepository _chaptersRepository;
  final VersesRepository _versesRepository;

  //Verses
  //=========
  //Search
  Future<List<Verse>> keywordSearch(bool basmala, String keyword,
      SearchMode searchMode, int chapterID) async {
    return await _versesRepository.search(
        basmala, keyword, searchMode, chapterID);
  }

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getLettersByChapterId(chapterId, basmala);
  }

  //Get Single Verse
  @override
  Future<Verse> getSingleVerse(int verseId, int chapterId) async {
    return await _versesRepository.getSingleVerse(verseId, chapterId);
  }

  //Get Verses By Chapter ID
  Future<List<Verse>> getVersesByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getVersesByChapterId(chapterId, basmala);
  }

  //Chapters
  //========
  //Get All Chapters Without Quran
  Future<List<Chapter>> getAll({required bool includeWholeQuran}) async {
    return await _chaptersRepository.getAll(
      includeWholeQuran: includeWholeQuran,
    );
  }

  //Get Chapter Name
  Future<String?> getChapterName(int chapterID) async {
    return await _chaptersRepository.getChapterNameById(chapterID);
  }

  //Get Full Chapter
  Future<Chapter> getChapter(int chapterID) async {
    return await _chaptersRepository.getFullChapterById(chapterID);
  }
}
