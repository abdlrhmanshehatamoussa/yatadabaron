import 'package:Yatadabaron/modules/domain.module.dart';

abstract class IMushafService {
  //Verses
  //=========
  //Search
  Future<List<VerseDTO>> keywordSearch(
      bool basmala, String keyword, SearchMode searchMode, int chapterID);

  //Chapters
  //========
  //Get All Chapters Including Whole-Quran
  Future<List<ChapterSimpleDTO>> getMushafChaptersIncludingWholeQuran();

  //Get All Chapters Without Quran
  Future<List<ChapterSimpleDTO>> getMushafChapters();

  //Get Chapter Name
  Future<String?> getChapterNameById(int chapterID);

  //Get Full Chapter
  Future<ChapterFullDTO> getFullChapterById(int chapterID);

  //Get Verses By Chapter ID
  Future<List<VerseDTO>> getVersesByChapterId(int chapterId, bool basmala);

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala);
}
