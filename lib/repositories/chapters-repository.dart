import '../dtos/chapter-full-dto.dart';
import '../dtos/chapter-simple-dto.dart';
import '../repositories/generic-repository.dart';
import '../helpers/localization.dart';

class ChaptersRepository extends GenericRepository {
  static ChaptersRepository instance = ChaptersRepository._();

  ChaptersRepository._();

  static const String TABLE_NAME = "chapters";

  Future<String> getChapterNameById(int id) async {
    if (id == 0) {
      return Localization.WHOLE_QURAN;
    }

    //Prepare Query
    String query =
        "select arabic as name from chapters where c0sura = $id limit 1";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> results = await database.rawQuery(query);
    if (results.length > 0) {
      return results[0]["name"];
    } else {
      return "";
    }
  }

  Future<List<ChapterSimpleDTO>> getChaptersSimple(
      {bool includeWholeQuran = false}) async {
    //Prepare Query
    String query = "select c0sura as id,arabic as name from chapters";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> chapters = await database.rawQuery(query);
    List<ChapterSimpleDTO> results =
        chapters.map((Map<String, dynamic> result) {
      String name = result["name"];
      int id = result["id"];
      return ChapterSimpleDTO(id, name);
    }).toList();
    if (includeWholeQuran) {
      results.insert(0, ChapterSimpleDTO.holyQuran());
    }
    return results;
  }

  Future<ChapterFullDTO> getFullChapterById(int id) async {
    //Prepare Query
    String query = "SELECT * FROM chapters WHERE c0sura = $id limit 1";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> chapters = await database.rawQuery(query);
    if (chapters.length > 0) {
      Map<String, dynamic> chapter = chapters[0];
      int id = chapter["c0sura"];
      String name = chapter["arabic"];
      String chapterLocation = chapter["localtion"];
      int versesCount = chapter["ayah"];
      String sajdaLocation = chapter["sajda"];
      return ChapterFullDTO(id, name, chapterLocation, versesCount, sajdaLocation);
    }

    throw Exception("Invalid Chapter Id");
  }
}
