import 'package:yatadabaron/modules/domain.module.dart';

abstract class IMushafService {
  //Verses
  //=========
  //Search
  Future<List<Verse>> keywordSearch(
      bool basmala, String keyword, SearchMode searchMode, int chapterID);

  //Get Verses By Chapter ID
  Future<List<Verse>> getVersesByChapterId(int chapterId, bool basmala);

  //Get Single Verse
  Future<Verse> getSingleVerse(int verseId, int chapterId);

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala);

  //Chapters
  //========
  //Get All Chapters Without Quran
  Future<List<Chapter>> getAll({required bool includeWholeQuran});

  //Get Chapter Name
  Future<String?> getChapterName(int chapterID);

  //Get Full Chapter
  Future<Chapter> getChapter(int chapterID);
}
