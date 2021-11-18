import 'package:yatadabaron/models/module.dart';
import 'verse.dart';

class VerseSearchResult {
  final Verse verse;
  final List<VerseMatch> matches;

  int get count => matches.length;

  VerseSearchResult({
    required this.verse,
    required this.matches,
  });
}
