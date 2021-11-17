import 'package:yatadabaron/models/module.dart';

import 'verse.dart';

class VerseSearchResult {
  final Verse verse;
  final int count;
  final List<VerseSlice> slices;

  VerseSearchResult({
    required this.verse,
    required this.count,
    required this.slices,
  });
}
