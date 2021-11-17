import 'package:yatadabaron/models/module.dart';
import 'search_settings.dart';

class SearchResult {
  final List<VerseSearchResult> results;
  final SearchSettings settings;
  SearchResult({
    required this.settings,
    required this.results,
  });

  List<VerseCollection> get collections {
    List<VerseCollection> cols = [];
    results.forEach((VerseSearchResult result) {
      String chapterName = result.verse.chapterName!;
      List<VerseSearchResult> filteredResults =
          results.where((v) => v.verse.chapterName == chapterName).toList();
      cols.add(
        VerseCollection(
          results: filteredResults,
          collectionName: chapterName,
        ),
      );
    });
    cols.sort((a, b) => a.results.length.compareTo(b.results.length));
    return cols.reversed.toList();
  }

  int get totalCount {
    return collections
        .map((VerseCollection collection) => collection.resultsCount)
        .reduce((a, b) => a + b);
  }
}
