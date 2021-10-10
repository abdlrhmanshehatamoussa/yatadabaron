import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/modules/persistence.module.dart';

class ChaptersRepository extends DatabaseRepository {
  static ChaptersRepository instance = ChaptersRepository._();

  ChaptersRepository._();

  static const String TABLE_NAME = "chapters";

  Future<String?> getChapterNameById(int id) async {
    if (id == 0) {
      return Localization.WHOLE_QURAN;
    }

    //Prepare Query
    String query =
        "select arabic as name from chapters where c0sura = $id limit 1";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> results = await database!.rawQuery(query);
    if (results.length > 0) {
      return results[0]["name"];
    } else {
      return "";
    }
  }

  Future<List<Chapter>> getAll({bool includeWholeQuran = false}) async {
    //Prepare Query
    String query = "select * from chapters";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> chapters = await database!.rawQuery(query);
    List<Chapter> results = chapters.map((Map<String, dynamic> chapterMap) {
      return Chapter.fromMap(chapterMap);
    }).toList();
    if (includeWholeQuran) {
      results.insert(0, Chapter.holyQuran());
    }
    return results;
  }
  
  Future<Chapter> getFullChapterById(int id) async {
    //Prepare Query
    String query = "SELECT * FROM chapters WHERE c0sura = $id limit 1";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> chapters = await database!.rawQuery(query);
    if (chapters.length > 0) {
      Map<String, dynamic> map = chapters[0];
      return Chapter.fromMap(map);
    }

    throw Exception("Invalid Chapter Id");
  }
}
