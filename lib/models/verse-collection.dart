import 'package:yatadabaron/models/verse_search_result.dart';

class VerseCollection {
  final List<VerseSearchResult> results;
  final String collectionName;

  VerseCollection({
    required this.results,
    required this.collectionName,
  });

  int get resultsCount {
    return results.map((r) => r.count).reduce((a, b) => a + b);
  }
}
