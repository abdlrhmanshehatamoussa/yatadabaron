import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/simple/module.dart';
import '../../commons/database_mixin.dart';

abstract class IVersesService {
  //Search
  Future<SearchResult> keywordSearch(KeywordSearchSettings settings);

  //Get Verses By Chapter ID
  Future<List<Verse>> getVersesByChapterId(int? chapterId, bool basmala);

  //Get Single Verse
  Future<Verse> getSingleVerse(int verseId, int chapterId);

  //Get letters frequency
  Future<List<LetterFrequency>> getLetterFrequency(
      BasicSearchSettings settings);
}

class VersesService
    with DatabaseMixin
    implements IVersesService, ISimpleService {
  final String databaseFilePath;

  VersesService({
    required this.databaseFilePath,
  });

  static const String _TABLE_NAME_BASMALA = "verses_with_basmala";
  static const String _TABLE_NAME_NO_BASMALA = "verses";

  List<SearchSlice> _generateSlices(
    String haystack,
    String needle,
    SearchMode mode,
  ) {
    List<List<int>> spans;
    switch (mode) {
      case SearchMode.START:
        int firstIndex = haystack.indexOf(needle);
        spans = [
          [firstIndex, firstIndex + needle.length - 1],
        ];
        break;
      case SearchMode.END:
        int lastIndex = haystack.lastIndexOf(needle);
        spans = [
          [lastIndex, lastIndex + needle.length - 1],
        ];
        break;
      case SearchMode.WORD:
        spans = Utils.findAllSpans(needle, haystack);
        spans = spans.where((List<int> span) {
          int prevIndex = span[0] - 1;
          int nextIndex = span[1] + 1;
          bool validPrev = (prevIndex < 0) || haystack[prevIndex] == " ";
          bool validNext =
              (nextIndex >= haystack.length) || haystack[nextIndex] == " ";
          return validPrev && validNext;
        }).toList();
        break;
      case SearchMode.WITHIN:
        spans = Utils.findAllSpans(needle, haystack);
        break;
      default:
        throw Exception("Invalid search mode");
    }
    List<SearchSlice> results = [];
    List<int> leading = spans.first;
    if (leading[0] > 0) {
      //The last 1 is added for substring
      int end = (leading[0] - 1);
      String toAdd = haystack.substring(0, end + 1);
      results.add(SearchSlice(text: toAdd, match: false, start: 0, end: end));
    }
    for (var i = 0; i < spans.length; i++) {
      List<int> crnt = spans[i];
      int s = crnt[0];
      int e = crnt[1];
      String toAdd = haystack.substring(s, e + 1);
      results.add(SearchSlice(text: toAdd, match: true, start: s, end: e));
      if (i + 1 < spans.length) {
        List<int> nxt = spans[i + 1];
        if (nxt[0] - crnt[1] > 1) {
          int ss = crnt[1] + 1;
          int ee = nxt[0] - 1;
          //The last 1 is added for substring
          String toAdd = haystack.substring(ss, ee + 1);
          results.add(
            SearchSlice(
              text: toAdd,
              match: false,
              start: ss,
              end: ee,
            ),
          );
        }
      }
    }
    List<int> trailing = spans.last;
    int lastIndex = haystack.length - 1;
    if (trailing[1] < lastIndex) {
      //The last 1 is added for substring
      int s = trailing[1] + 1;
      int e = lastIndex;
      String toAdd = haystack.substring(s, e + 1);
      results.add(SearchSlice(text: toAdd, match: false, start: s, end: e));
    }
    return results;
  }

  Future<List<Verse>> _searchInDB(KeywordSearchSettings searchSettings) async {
    bool basmala = searchSettings.basmala;
    String keyword = searchSettings.keyword;
    SearchMode searchMode = searchSettings.mode;
    String table = basmala ? _TABLE_NAME_BASMALA : _TABLE_NAME_NO_BASMALA;
    String chapterCondition;
    if (searchSettings.searchInWholeQuran) {
      chapterCondition = " > 0 ";
    } else {
      chapterCondition = " = ${searchSettings.chapterID!} ";
    }
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
    List<Map<String, dynamic>> versesDB = await db.rawQuery(query);

    //Map
    List<Verse> results = versesDB.map((Map<String, dynamic> verseDB) {
      String chapterName = verseDB["chapter_name"];
      String verseText = verseDB["verse_text"];
      String verseTextTashkel = verseDB["verse_text_tashkel"];
      int verseID = verseDB["verse_id"];
      int chId = verseDB["chapter_id"];
      Verse verse = Verse(
        chapterId: chId,
        chapterName: chapterName,
        verseText: verseText,
        verseTextTashkel: verseTextTashkel,
        verseID: verseID,
      );
      return verse;
    }).toList();
    return results;
  }

  //Search
  @override
  Future<SearchResult> keywordSearch(
    KeywordSearchSettings searchSettings,
  ) async {
    List<Verse> versesDB = await _searchInDB(searchSettings);
    List<VerseSearchResult> results = versesDB.map((Verse v) {
      List<SearchSlice> slices = _generateSlices(
        v.verseText,
        searchSettings.keyword,
        searchSettings.mode,
      );
      return VerseSearchResult(verse: v, slices: slices);
    }).toList();
    return SearchResult(
      settings: searchSettings,
      results: results,
    );
  }

  //Get letters frequency
  @override
  Future<List<LetterFrequency>> getLetterFrequency(
    BasicSearchSettings settings,
  ) async {
    List<Verse> verses = await getVersesByChapterId(
      settings.chapterId,
      settings.basmala,
    );
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
        "FROM $_TABLE_NAME_NO_BASMALA as v "
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
  Future<List<Verse>> getVersesByChapterId(
    int? chapterId,
    bool basmala,
  ) async {
    //Prepare Query
    String table = basmala ? _TABLE_NAME_BASMALA : _TABLE_NAME_NO_BASMALA;
    String chapterCondition =
        (chapterId == null) ? "" : "WHERE sura = $chapterId";
    String query =
        "SELECT ayah as verse_id,text_tashkel as verse_text_tashkel,text as verse_text,sura as chapter_id "
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
      int chapterIdDB = verse["chapter_id"];
      Verse result = Verse(
        chapterId: chapterIdDB,
        verseText: verseText,
        verseTextTashkel: verseTextTashkel,
        verseID: verseID,
      );
      return result;
    }).toList();
    return results;
  }
}



    //This approach depends on mapping the words across the Emla2y and Usmani text
    // List<String> textEmla2yWords = textEmla2y.split(" ");
    // List<String> textTashkelWords = textTashkel.split(" ");
    // List<WordInfo> result = [];
    // for (var i = 0; i < textTashkelWords.length; i++) {
    //   WordInfo info = WordInfo();
    //   String tashkelWord = textTashkelWords[i];
    //   info.word = tashkelWord;
    //   if (keyword?.isNotEmpty ?? false) {
    //     if (i < textEmla2yWords.length) {
    //       String emla2yWord = textEmla2yWords[i];
    //       info[0] = emla2yWord.indexOf(keyword!);
    //       info.exact = (emla2yWord == keyword);
    //     }
    //   }
    //   result.add(info);
    // }
    // return result;

//Approach 2
// //1- Prepare the indices
// String firstLetter = keyword[0];
// List<int> indices = Utils.findIndicesOfChar(textTashkel, firstLetter);
// //2- Loop through and get the findings
// int l = keyword.length;
// List<String> findings = [];
// for (var index in indices) {
//   String finding = Utils.substring(
//     text: textTashkel,
//     startFrom: index,
//     count: l,
//     countIf: Utils.arabicLetters(),
//   );
//   findings.add(finding);
// }
// print(findings);
// //3- Search for the exact finding in the original text
// String exactFinding = "";
// for (var finding in findings) {
//   String findingReduced = Utils.reduce(
//     text: finding,
//     countIf: Utils.arabicLetters(),
//   );
//   if (findingReduced == keyword) {
//     exactFinding = finding;
//     break;
//   }
// }

// //4- Get the index of the exact finding
// int start;
// int end;
// int i = textTashkel.indexOf(exactFinding);
// if (i > -1) {
//   start = i;
//   end = start + exactFinding.length + 1;
// }

// return [
//   textTashkel.substring(0, start),
//   textTashkel.substring(start, end),
//   textTashkel.substring(end),
// ];

//Approach 1
// int b = text.indexOf(keyword);
// int k = keyword.length;
// List<String> arr = [
//   text.substring(0, b),
//   text.substring(b, b + k),
//   text.substring(b + k),
// ];
// return arr;