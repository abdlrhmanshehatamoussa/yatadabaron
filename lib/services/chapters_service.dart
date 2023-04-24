import 'dart:convert';

import 'package:http/http.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/database_mixin.dart';

class ChaptersService with DatabaseMixin implements IChaptersService {
  final String databasePath;

  ChaptersService({
    required this.databasePath,
  });

  @override
  Future<List<Chapter>> getAll() async {
    //Prepare Query
    String query = "select * from chapters";

    //Execute
    var db = await database(this.databasePath);
    List<Map<String, dynamic>> chapters = await db.rawQuery(query);
    List<Chapter> results = chapters.map((Map<String, dynamic> chapterMap) {
      return Chapter.fromMap(chapterMap);
    }).toList();
    return results;
  }

  @override
  Future<String> getChapterName(int chapterID) async {
    //Prepare Query
    String query =
        "select arabic as name from chapters where c0sura = $chapterID limit 1";

    //Execute
    var db = await database(this.databasePath);
    List<Map<String, dynamic>> results = await db.rawQuery(query);
    if (results.length > 0) {
      return results[0]["name"];
    } else {
      return "";
    }
  }

  @override
  Future<Chapter> getChapter(int chapterID) async {
    //Prepare Query
    String query = "SELECT * FROM chapters WHERE c0sura = $chapterID limit 1";

    //Execute
    var db = await database(this.databasePath);
    List<Map<String, dynamic>> chapters = await db.rawQuery(query);
    if (chapters.length > 0) {
      Map<String, dynamic> map = chapters[0];
      return Chapter.fromMap(map);
    }

    throw Exception("Invalid Chapter Id");
  }
}

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
