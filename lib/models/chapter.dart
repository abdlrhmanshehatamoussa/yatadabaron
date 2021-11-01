
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'enums.dart';

class Chapter {
  final int chapterID;
  final String chapterNameAR;
  final String chapterNameEN;
  final ChapterLocation location;
  final int sajdaLocation;
  final int verseCount;

  Chapter({
    required this.chapterID,
    required this.chapterNameAR,
    required this.chapterNameEN,
    required this.location,
    required this.sajdaLocation,
    required this.verseCount,
  });

  String get summary {
    String locationStr = location == ChapterLocation.MAKKI
        ? Localization.MECCA_LOCATION
        : Localization.MADINA_LOCATION;
    String versesCountInArabic =
        Utils.convertToArabiNumber(verseCount, reverse: false);
    String prefix = Localization.VERSE;
    if (verseCount <= 10) {
      prefix = Localization.VERSES;
    }
    return "$locationStr | $versesCountInArabic $prefix";
  }

  static Chapter fromMap(Map<String, dynamic> map) {
    String locationInt = map["localtion"];
    ChapterLocation location =
        (locationInt == "1") ? ChapterLocation.MAKKI : ChapterLocation.MADANI;
    Chapter result = Chapter(
      chapterID: map["c0sura"],
      chapterNameAR: map["arabic"],
      chapterNameEN: map["latin"],
      location: location,
      sajdaLocation: int.tryParse(map["sajda"]) ?? 0,
      verseCount: map["ayah"],
    );
    return result;
  }

  static Chapter holyQuran() {
    return Chapter(
      chapterID: 0,
      chapterNameAR: Localization.WHOLE_QURAN,
      chapterNameEN: "Holy Quran",
      location: ChapterLocation.MAKKI,
      verseCount: 6236,
      sajdaLocation: 0,
    );
  }
}
