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
}
