import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/modules/persistence.module.dart';
import './generic-repository.dart';

class TafseerRepository extends GenericRepository {
  static TafseerRepository instance = TafseerRepository._();

  TafseerRepository._();

  static const String TAFSEER_TABLE_NAME = "tafseer";
  static const String VERSES_TAFSEER_TABLE_NAME = "verses_tafseer";

  Future<TafseerResultDTO> getTafseer({
    required int chapterId,
    required int verseId,
    required int tafseerId,
  }) async {
    //Prepare Query
    String query = '''
select
vt.nass as tafseer_text
from $VERSES_TAFSEER_TABLE_NAME as vt
where vt.sura = $chapterId and vt.ayah = $verseId and vt.tafseer = $tafseerId
    ''';

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> rows = await database!.rawQuery(query);

    //Map
    String? tafseerText;
    if (rows.isNotEmpty) {
      var row = rows.first;
      tafseerText = row["tafseer_text"];
    }
    TafseerResultDTO dto = TafseerResultDTO(
      tafseerText: tafseerText,
      tafseerID: tafseerId,
    );
    return dto;
  }

  Future<List<TafseerDTO>> getAvailableTafseers() async {
    //Prepare Query
    String query = "select * from `$TAFSEER_TABLE_NAME`";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> results = await database!.rawQuery(query);
    return results.map((Map<String, dynamic> result) {
      return TafseerDTO(
        tafseerId: result["id"],
        tafseerName: result["name"],
        tafseerNameEnglish: result["name_english"],
      );
    }).toList();
  }
}
