import '../dtos/letter-frequency.dart';
import '../dtos/verse-dto.dart';
import '../enums/enums.dart';
import '../helpers/utils.dart';
import '../repositories/generic-repository.dart';

class VersesRepository extends GenericRepository {
  static VersesRepository instance = VersesRepository._();

  VersesRepository._();

  static const String TABLE_NAME = "verses";
  static const String VIEW_NAME = "verses_no_basmala";

  Future<List<VerseDTO>> search(
      bool basmala, String keyword, SearchMode mode, int chapterId) async {
    String table = basmala ? TABLE_NAME : VIEW_NAME;
    String chapterCondition = (chapterId > 0) ? " = $chapterId " : " > 0 ";
    String textCondition = "";
    switch (mode) {
      case SearchMode.START:
        textCondition += "ve.text like '$keyword%'";
        break;
      case SearchMode.END:
        textCondition += "ve.text like '%$keyword'";
        break;
      case SearchMode.WORD:
        textCondition +=
            "(ve.text like '% $keyword %' or ve.text like '$keyword %' or ve.text like '% $keyword')";
        break;
      case SearchMode.WITHIN:
        textCondition += "ve.text like '%$keyword%'";
        break;
    }

    //Prepare Query
    String query =
        "SELECT ch.arabic as chapter_name,ve.ayah as verse_id,ve.text as verse_text,ve.text_tashkel as verse_text_tashkel "
        "FROM $table ve "
        "INNER JOIN chapters ch on ve.sura = ch.c0sura "
        "WHERE ve.sura $chapterCondition "
        "and $textCondition";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> verses = await database.rawQuery(query);

    //Map
    List<VerseDTO> results = verses.map((Map<String, dynamic> verse) {
      String chapterName = verse["chapter_name"];
      String verseText = verse["verse_text"];
      String verseTextTashkel = verse["verse_text_tashkel"];
      int verseID = verse["verse_id"];
      VerseDTO result =
          VerseDTO(chapterName, verseText, verseTextTashkel, verseID);
      return result;
    }).toList();
    return results;
  }

  Future<List<VerseDTO>> getVersesByChapterId(int id, bool basmala) async {
    //Prepare Query
    String table = basmala ? TABLE_NAME : VIEW_NAME;
    String chapterCondition = (id == 0) ? "" : "WHERE sura = $id";
    String query =
        "SELECT ayah as verse_id,text_tashkel as verse_text_tashkel,text as verse_text "
        "FROM $table "
        "$chapterCondition";

    //Check DB
    await checkDB();

    //Execute
    List<Map<String, dynamic>> verses = await database.rawQuery(query);

    //Map
    List<VerseDTO> results = verses.map((Map<String, dynamic> verse) {
      String chapterName = "";
      String verseText = verse["verse_text"];
      String verseTextTashkel = verse["verse_text_tashkel"];
      int verseID = verse["verse_id"];
      VerseDTO result =
          VerseDTO(chapterName, verseText, verseTextTashkel, verseID);
      return result;
    }).toList();
    return results;
  }

  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala) async {
    List<VerseDTO> verses = await getVersesByChapterId(chapterId, basmala);
    String chapterText = verses.map((VerseDTO verse) => verse.verseText).join();

    List<LetterFrequency> frequencies = [];
    Utils.arabicLetters().forEach((String letter) {
      int count = 0;
      int l1 = chapterText.length;
      int l2 = chapterText.replaceAll(letter, '').length;
      count = count + (l1 - l2);
      frequencies.add(LetterFrequency(letter, count));
    });
    frequencies.sort((a, b) => a.frequency.compareTo(b.frequency));
    return frequencies.reversed.toList();
  }
}
