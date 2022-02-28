import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/commons/database_mixin.dart';

class ChaptersService
    with DatabaseMixin
    implements IChaptersService, ISimpleService {
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
