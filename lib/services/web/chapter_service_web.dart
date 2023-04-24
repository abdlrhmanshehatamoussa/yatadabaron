import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class ChaptersServiceWeb extends IChaptersService {
  @override
  Future<List<Chapter>> getAll() async {
    var response = await get(Uri.parse("http://api.alquran.cloud/v1/meta"));
    var body = jsonDecode(response.body);
    var result = <Chapter>[];
    for (var element in body["data"]["surahs"]["references"]) {
      result.add(Chapter(
        chapterID: element["number"],
        chapterNameAR: element["name"],
        chapterNameEN: element["englishName"],
        location: element["revelationType"] == "Meccan"
            ? ChapterLocation.MAKKI
            : ChapterLocation.MADANI,
        sajdaLocation: 0,
        verseCount: element["numberOfAyahs"],
      ));
    }
    return result;
  }

  @override
  Future<Chapter> getChapter(int chapterID) async {
    var all = await getAll();
    return all.firstWhere((c) => c.chapterID == chapterID);
  }

  @override
  Future<String> getChapterName(int chapterID) async {
    var all = await getAll();
    return all.firstWhere((c) => c.chapterID == chapterID).chapterNameAR;
  }
}
