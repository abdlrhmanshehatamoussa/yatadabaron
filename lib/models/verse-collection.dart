import 'package:yatadabaron/models/enums.dart';

import 'verse.dart';

class VerseCollection {
  final List<Verse> verses;
  final String? collectionName;

  VerseCollection({
    required this.verses,
    required this.collectionName,
  });

  static List<VerseCollection> group(List<Verse> results) {
    List<VerseCollection> collections = [];
    List<String?> chapterNames =
        results.map((v) => v.chapterName).toSet().toList();
    chapterNames.forEach((String? chapter) {
      List<Verse> verses =
          results.where((v) => v.chapterName == chapter).toList();
      collections.add(
        VerseCollection(
          verses: verses,
          collectionName: chapter,
        ),
      );
    });
    collections.sort((a, b) => a.verses.length.compareTo(b.verses.length));
    return collections.reversed.toList();
  }

  int countKeyword(String keyword, SearchMode mode) {
    int count = verses
        .map((v) => v.countKeyword(keyword, mode))
        .reduce((a, b) => a + b);
    return count;
  }
}
