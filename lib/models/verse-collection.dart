import 'package:yatadabaron/models/verse_search_result.dart';

class VerseCollection {
  final List<VerseSearchResult> results;
  final String collectionName;

  VerseCollection({
    required this.results,
    required this.collectionName,
  });

  int get resultsCount {
    int count = 0;
    for (var result in results) {
      count += result.slices.where((s) => s.match).length;
    }
    return count;
  }
}
