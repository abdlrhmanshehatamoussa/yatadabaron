import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/helpers/database_service.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'interfaces/module.dart';

class VersesService
    with DatabaseService
    implements IVersesService, ISimpleService {
  final String databaseFilePath;

  VersesService({
    required this.databaseFilePath,
  });

  static const String TABLE_NAME_BASMALA = "verses_with_basmala";
  static const String TABLE_NAME_NO_BASMALA = "verses";

  @override
  Type get getAs => IVersesService;

  //Search
  @override
  Future<List<Verse>> keywordSearch(
    bool basmala,
    String keyword,
    SearchMode searchMode,
    int chapterId,
  ) async {
    String table = basmala ? TABLE_NAME_BASMALA : TABLE_NAME_NO_BASMALA;
    String chapterCondition = (chapterId > 0) ? " = $chapterId " : " > 0 ";
    String textCondition = "";
    switch (searchMode) {
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
      default:
        break;
    }

    //Prepare Query
    String query =
        "SELECT ch.arabic as chapter_name,ve.ayah as verse_id,ve.text as verse_text,ve.text_tashkel as verse_text_tashkel,ch.c0sura as chapter_id "
        "FROM $table ve "
        "INNER JOIN chapters ch on ve.sura = ch.c0sura "
        "WHERE ve.sura $chapterCondition "
        "and $textCondition";

    var db = await database(this.databaseFilePath);

    //Execute
    List<Map<String, dynamic>> verses = await db.rawQuery(query);

    //Map
    List<Verse> results = verses.map((Map<String, dynamic> verse) {
      String chapterName = verse["chapter_name"];
      String verseText = verse["verse_text"];
      String verseTextTashkel = verse["verse_text_tashkel"];
      int verseID = verse["verse_id"];
      int chId = verse["chapter_id"];
      Verse result = Verse(
        chapterId: chId,
        chapterName: chapterName,
        verseText: verseText,
        verseTextTashkel: verseTextTashkel,
        verseID: verseID,
      );
      return result;
    }).toList();
    return results;
  }

  //Get letters frequency
  @override
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala) async {
    List<Verse> verses = await getVersesByChapterId(chapterId, basmala);
    String chapterText = verses.map((Verse verse) => verse.verseText).join();

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

  //Get Single Verse
  @override
  Future<Verse> getSingleVerse(int verseId, int chapterId) async {
    //Prepare Query
    String query =
        "SELECT v.ayah as verse_id,text_tashkel as verse_text_tashkel,text as verse_text,c.arabic as chapter_name "
        "FROM $TABLE_NAME_NO_BASMALA as v "
        "INNER JOIN CHAPTERS as c on c.c0sura = v.sura "
        "where v.ayah = $verseId and v.sura = $chapterId";

    //Check DB
    var db = await database(this.databaseFilePath);

    //Execute
    List<Map<String, dynamic>> verses = await db.rawQuery(query);

    //Map
    Map<String, dynamic> verse = verses.first;
    String chapterName = verse["chapter_name"];
    String verseText = verse["verse_text"];
    String verseTextTashkel = verse["verse_text_tashkel"];
    int verseID = verse["verse_id"];
    Verse result = Verse(
      chapterId: chapterId,
      chapterName: chapterName,
      verseText: verseText,
      verseTextTashkel: verseTextTashkel,
      verseID: verseID,
    );
    return result;
  }

  //Get Verses By Chapter ID
  @override
  Future<List<Verse>> getVersesByChapterId(int chapterId, bool basmala) async {
    //Prepare Query
    String table = basmala ? TABLE_NAME_BASMALA : TABLE_NAME_NO_BASMALA;
    String chapterCondition = (chapterId == 0) ? "" : "WHERE sura = $chapterId";
    String query =
        "SELECT ayah as verse_id,text_tashkel as verse_text_tashkel,text as verse_text "
        "FROM $table "
        "$chapterCondition";

    //Check DB
    var db = await database(this.databaseFilePath);

    //Execute
    List<Map<String, dynamic>> verses = await db.rawQuery(query);

    //Map
    List<Verse> results = verses.map((Map<String, dynamic> verse) {
      String verseText = verse["verse_text"];
      String verseTextTashkel = verse["verse_text_tashkel"];
      int verseID = verse["verse_id"];
      Verse result = Verse(
        chapterId: chapterId,
        verseText: verseText,
        verseTextTashkel: verseTextTashkel,
        verseID: verseID,
      );
      return result;
    }).toList();
    return results;
  }
}
