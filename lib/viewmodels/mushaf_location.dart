class MushafLocation {
  MushafLocation({
    required this.chapterId,
    required this.verseId,
  });

  final int chapterId;
  final int verseId;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map["chapterId"] = chapterId;
    map["verseId"] = verseId;
    return map;
  }

  String get uniqueId => "$chapterId|$verseId";

  static MushafLocation? fromJson(Map<String, dynamic> jsonObj) {
    String chapterIdStr = jsonObj["chapterId"].toString();
    String verseIdStr = jsonObj["verseId"].toString();
    int chapterId = int.tryParse(chapterIdStr) ?? 0;
    int verseId = int.tryParse(verseIdStr) ?? 0;
    if ((chapterId * verseId) > 0) {
      return MushafLocation(
        chapterId: chapterId,
        verseId: verseId,
      );
    }
    return null;
  }
}
