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
vt.tafseer as tafseer_id,
vt.sura as chapter_id,
vt.ayah as verse_id,
vt.nass as tafseer_text,
c.arabic as chapter_name,
v.text_tashkel as verse_text_tashkel,
t.name as tafseer_name,
t.name_english as tafseer_name_english
from $VERSES_TAFSEER_TABLE_NAME as vt
inner join ${ChaptersRepository.TABLE_NAME} as c on vt.sura = c.c0sura
inner join ${VersesRepository.TABLE_NAME_NO_BASMALA} as v on v.ayah = vt.ayah and v.sura=vt.sura
inner join $TAFSEER_TABLE_NAME as t on t.id = vt.tafseer
where vt.sura = $chapterId and vt.ayah = $verseId and vt.tafseer = $tafseerId
    ''';

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> rows = await database!.rawQuery(query);

    //Map
    var row = rows.first;
    TafseerResultDTO dto = TafseerResultDTO(
      chapterId: row["chapter_id"],
      verseId: row["verse_id"],
      tafseerId: row["tafseer_id"],
      chapterName: row["chapter_name"],
      tafseerText: row["tafseer_text"],
      verseTextTashkeel: row["verse_text_tashkel"],
      tafseerName: row["tafseer_name"],
      tafseerNameEnglish: row["tafseer_name_english"],
    );
    return dto;
  }

  Future<List<TafseerDTO>> getAvailableTafseers() async {
    //Prepare Query
    String query =
        "select * from `$TAFSEER_TABLE_NAME` where id in (select distinct tafseer from `$VERSES_TAFSEER_TABLE_NAME`)";

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
