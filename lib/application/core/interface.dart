import 'package:yatadabaron/modules/domain.module.dart';

abstract class IMushafService {
  //Verses
  //=========
  //Search
  Future<List<VerseDTO>> keywordSearch(
      bool basmala, String keyword, SearchMode searchMode, int chapterID);

  //Get Verses By Chapter ID
  Future<List<VerseDTO>> getVersesByChapterId(int chapterId, bool basmala);

  //Get Single Verse
  Future<VerseDTO> getSingleVerse(int verseId, int chapterId);

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala);

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

  //Tafseer
  //========
  Future<List<TafseerSource>> getTafseerNames();
  Future<VerseTafseer> getTafseer(
      int tafseerId, int verseId, int chapterId);
}
