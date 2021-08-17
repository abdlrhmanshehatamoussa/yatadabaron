import 'package:yatadabaron/domain/dtos/verse-dto.dart';

class VerseTafseer {
  final int tafseerSourceID;
  final int verseId;
  final String? tafseerText;

  VerseDTO? verse;

  VerseTafseer({
    required this.tafseerSourceID,
    required this.tafseerText,
    required this.verseId,
  });
}
