import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class IVersesService extends SimpleService {
  //Search
  Future<SearchResult> keywordSearch(KeywordSearchSettings settings);

  //Get Verses By Chapter ID
  Future<List<Verse>> getVersesByChapterId(int? chapterId, bool basmala);

  //Get Single Verse
  Future<Verse> getSingleVerse(int verseId, int chapterId);

  //Get letters frequency
  Future<List<LetterFrequency>> getLetterFrequency(
      BasicSearchSettings settings);
}
