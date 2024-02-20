import 'package:yatadabaron/models/enums.dart';

class Bookmark {
  static const String _CHAPTER_ID = "chapter_id";
  static const String _VERSE_ID = "verse_id";
  static const String _MUSHAF_TYPE = "mushaf_type";

  Bookmark({
    required this.chapterId,
    required this.verseId,
    required this.mushafType,
  });

  final int chapterId;
  final int verseId;
  final MushafType mushafType;
  String get uniqueId => "$chapterId|$verseId|$mushafType";

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map[_CHAPTER_ID] = chapterId;
    map[_VERSE_ID] = verseId;
    map[_MUSHAF_TYPE] = mushafType.index;
    return map;
  }

  static Bookmark fromJson(Map<String, dynamic> jsonObj) {
    String chapterIdStr = jsonObj[_CHAPTER_ID].toString();
    String verseIdStr = jsonObj[_VERSE_ID].toString();
    dynamic mushafTypeObj = jsonObj[_MUSHAF_TYPE];
    MushafType mushafType = mushafTypeObj != null
        ? MushafType.values[mushafTypeObj]
        : MushafType.HAFS;
    int chapterId = int.tryParse(chapterIdStr) ?? 0;
    int verseId = int.tryParse(verseIdStr) ?? 0;
    if (chapterId == 0 || verseId == 0) {
      throw Exception("Invalid bookmark data");
    }
    return Bookmark(
      chapterId: chapterId,
      verseId: verseId,
      mushafType: mushafType,
    );
  }
}
