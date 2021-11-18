import 'package:yatadabaron/models/module.dart';
import 'verse.dart';

class VerseSearchResult {
  final Verse verse;
  final List<VerseSlice> textTashkeelMatches;
  final List<VerseSlice> textMatches;

  int get count => textTashkeelMatches.where((s) => s.matched).length;

  VerseSearchResult({
    required this.verse,
    required this.textTashkeelMatches,
    required this.textMatches,
  });
}
