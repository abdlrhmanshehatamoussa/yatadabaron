import 'package:Yatadabaron/modules/domain.module.dart';
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
    return TafseerResultDTO(
      chapterId: chapterId,
      verseId: verseId,
      tafseerId: tafseerId,
      chapterName: "",
      tafseer: tafseerId.toString(),
      tafseerName: "",
      verseTextTashkeel: verseId.toString(),
    );
    //TODO:

    //Prepare Query
    String query = "";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> verses = await database!.rawQuery(query);

    //Map
    List<TafseerResultDTO> results = verses.map((Map<String, dynamic> result) {
      return TafseerResultDTO(
          chapterId: chapterId,
          verseId: verseId,
          tafseerId: tafseerId,
          chapterName: "",
          tafseer: "",
          tafseerName: "",
          verseTextTashkeel: "");
    }).toList();
    return results.first;
  }

  Future<List<TafseerDTO>> getAvailableTafseers() async {
    //TODO:
    return [
      TafseerDTO(tafseerId: 1, tafseerName: "ابن كثير"),
      TafseerDTO(tafseerId: 2, tafseerName: "الطبري"),
    ];
  }
}
