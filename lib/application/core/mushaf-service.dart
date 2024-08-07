import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class MushafService implements IMushafService {
  MushafService(this._chaptersRepository, this._versesRepository);

  final ChaptersRepository _chaptersRepository;

  final VersesRepository _versesRepository;

  //Verses
  //=========
  //Search
  Future<List<VerseDTO>> keywordSearch(bool basmala, String keyword,
      SearchMode searchMode, int chapterID) async {
    return await _versesRepository.search(
        basmala, keyword, searchMode, chapterID);
  }

  //Chapters
  //========
  //Get All Chapters Including Whole-Quran
  Future<List<ChapterSimpleDTO>> getMushafChaptersIncludingWholeQuran() async {
    return await _chaptersRepository.getChaptersSimple(includeWholeQuran: true);
  }

  //Get All Chapters Without Quran
  Future<List<ChapterSimpleDTO>> getMushafChapters() async {
    return await _chaptersRepository.getChaptersSimple(
        includeWholeQuran: false);
  }

  //Get Chapter Name
  Future<String?> getChapterNameById(int chapterID) async {
    return await _chaptersRepository.getChapterNameById(chapterID);
  }

  //Get Full Chapter
  Future<ChapterFullDTO> getFullChapterById(int chapterID) async {
    return await _chaptersRepository.getFullChapterById(chapterID);
  }

  //Get Verses By Chapter ID
  Future<List<VerseDTO>> getVersesByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getVersesByChapterId(chapterId, basmala);
  }

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getLettersByChapterId(chapterId, basmala);
  }
}
