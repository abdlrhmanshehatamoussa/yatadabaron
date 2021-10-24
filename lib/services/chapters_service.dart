import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/helpers/database_repository.dart';
import 'interfaces/i_chapters_service.dart';

class ChaptersService extends DatabaseRepository implements IChaptersService {
  @override
  Future<List<Chapter>> getAll({required bool includeWholeQuran}) async {
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

  @override
  Future<String?> getChapterName(int chapterID) async {
    if (chapterID == 0) {
      return Localization.WHOLE_QURAN;
    }

    //Prepare Query
    String query =
        "select arabic as name from chapters where c0sura = $chapterID limit 1";

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

  @override
  Future<Chapter> getChapter(int chapterID) async {
    //Prepare Query
    String query = "SELECT * FROM chapters WHERE c0sura = $chapterID limit 1";

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