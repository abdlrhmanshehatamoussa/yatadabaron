import 'package:yatadabaron/models/module.dart';

abstract class IVersesService {
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
}