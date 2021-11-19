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
    List<String> chapterNames =
        results.map((r) => r.verse.chapterName!).toSet().toList();
    chapterNames.forEach((String chapterName) {
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

  int get totalMatchCount {
    int count = 0;
    for (var result in results) {
      count += result.slices.where((s) => s.match).length;
    }
    return count;
  }
}
