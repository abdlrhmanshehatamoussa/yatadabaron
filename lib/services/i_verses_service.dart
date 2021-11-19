import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

abstract class IVersesService {
  //Search
  Future<SearchResult> keywordSearch(KeywordSearchSettings settings);

  //Get Verses By Chapter ID
  Future<List<Verse>> getVersesByChapterId(
      int chapterId, bool basmala, bool wholeQuran);

  //Get Single Verse
  Future<Verse> getSingleVerse(int verseId, int chapterId);

  //Get letters frequency
  Future<List<LetterFrequency>> getLetterFrequency(
      BasicSearchSettings settings);
}
