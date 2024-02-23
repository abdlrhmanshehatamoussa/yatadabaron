import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/database_mixin.dart';

class ChaptersService with DatabaseMixin implements IChaptersService {
  final String databasePath;
  final mushafTypeService = Simply.get<IMushafTypeService>();

  MushafType get currentMushafType => mushafTypeService.getMushafType();

  ChaptersService({
    required this.databasePath,
  });

  String _chapterColumnNames() {
    var map = {
      MushafType.HAFS: "ayah",
      MushafType.WARSH: "ayah_warsh",
      MushafType.QALOON: "ayah_qaloon",
      MushafType.DOORI: "ayah_doori",
    };
    var versesCountColumn = map[currentMushafType];
    return "c0sura,arabic,latin,localtion,sajda,$versesCountColumn as ayah";
  }

  @override
  Future<List<Chapter>> getAll() async {
    //Prepare Query
    String query = "select ${_chapterColumnNames()} from chapters";

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
    String query = "SELECT ${_chapterColumnNames()} FROM chapters WHERE c0sura = $chapterID limit 1";

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
