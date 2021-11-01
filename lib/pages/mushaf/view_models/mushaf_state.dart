import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/mushaf_settings.dart';

class MushafPageState {
  final List<Verse> verses;
  final Chapter chapter;
  final int startFromVerse;
  final MushafMode mode;
  final List<Chapter> chapters;

  MushafPageState({
    required this.startFromVerse,
    required this.mode,
    required this.chapter,
    required this.verses,
    required this.chapters,
  });
}
