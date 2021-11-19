import 'package:yatadabaron/models/module.dart';
import 'verse.dart';
 
class VerseSearchResult {
  final Verse verse;
  final List<SearchSlice> slices;

  int get count => slices.length;

  VerseSearchResult({
    required this.verse,
    required this.slices,
  });
}
