import 'verse.dart';

class VerseTafseer {
  final int tafseerSourceID;
  final int verseId;
  final String? tafseerText;

  Verse? verse;

  VerseTafseer({
    required this.tafseerSourceID,
    required this.tafseerText,
    required this.verseId,
  });
}
