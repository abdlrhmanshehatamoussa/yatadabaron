import 'package:yatadabaron/models/module.dart';
import 'search_settings.dart';

class SearchResult {
  final List<VerseCollection> collections;
  final SearchSettings settings;
  SearchResult(this.settings, this.collections);

  List<Verse> get verses {
    return collections.map((c) => c.verses).expand((v) => v).toList();
  }

  int get totalCount {
    int count = 0;
    collections.forEach((VerseCollection collection) {
      count += collection.countKeyword(settings.keyword, settings.mode);
    });
    return count;
  }
}
