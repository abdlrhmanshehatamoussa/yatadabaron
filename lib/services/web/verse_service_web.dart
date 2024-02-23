import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class VerseServiceWeb extends IVersesService {
  final String simpleEdition = "quran-uthmani-min";
  final String cleanEdition = "quran-simple-clean";
  String get editionsCommaSeparated => "$simpleEdition,$cleanEdition";

  @override
  Future<List<LetterFrequency>> getLetterFrequency(
      BasicSearchSettings settings) async {
    return [];
  }

  @override
  Future<Verse> getSingleVerse(int verseId, int chapterId) async {
    var response = await get(Uri.parse(
        "https://api.alquran.cloud/v1/ayah/$chapterId:$verseId/editions/$editionsCommaSeparated"));
    List<dynamic> editions = jsonDecode(response.body)["data"];

    var noTashkeelEdition = editions.firstWhere(
        (element) => element["edition"]["identifier"] == cleanEdition);

    var tashkeelEdition = editions.firstWhere(
        (element) => element["edition"]["identifier"] == simpleEdition);
    return Verse(
      chapterId: chapterId,
      verseID: verseId,
      verseText: noTashkeelEdition["text"],
      verseTextTashkel: tashkeelEdition["text"],
      chapterName: tashkeelEdition["surah"]["name"],
    );
  }

  @override
  Future<List<Verse>> getVersesByChapterId(int? chapterId) async {
    var url =
        "http://api.alquran.cloud/v1/surah/$chapterId/editions/$editionsCommaSeparated";
    var response = await get(Uri.parse(url));
    List<dynamic> editions = jsonDecode(response.body)["data"];
    var noTashkeelEdition = editions.firstWhere(
        (element) => element["edition"]["identifier"] == cleanEdition);
    var tashkeelEdition = editions.firstWhere(
        (element) => element["edition"]["identifier"] == simpleEdition);
    var result = <Verse>[];
    for (var i = 0; i < tashkeelEdition["ayahs"].length; i++) {
      var tashkeelAyah = tashkeelEdition["ayahs"][i];
      var noTashkeelAyah = noTashkeelEdition["ayahs"][i];
      result.add(Verse(
        chapterId: chapterId ?? 0,
        verseID: tashkeelAyah["numberInSurah"],
        verseText: noTashkeelAyah["text"],
        verseTextTashkel: tashkeelAyah["text"],
        chapterName: tashkeelEdition["name"],
      ));
    }
    return result;
  }

  @override
  Future<SearchResult> keywordSearch(KeywordSearchSettings settings) async {
    if (settings.chapterID != null) {
      var verses = await getVersesByChapterId(settings.chapterID);
      switch (settings.mode) {
        case SearchMode.START:
          verses = verses
              .where(
                (v) => v.verseText.startsWith(settings.keyword),
              )
              .toList();
          break;
        case SearchMode.END:
          verses = verses
              .where(
                (v) => v.verseText.endsWith(settings.keyword),
              )
              .toList();
          break;
        case SearchMode.WORD:
          verses = verses
              .where(
                (v) => v.verseText.contains(" ${settings.keyword} "),
              )
              .toList();
          break;
        case SearchMode.WITHIN:
          verses = verses
              .where(
                (v) => v.verseText.contains(settings.keyword),
              )
              .toList();
          break;
      }
      return SearchResult(
          settings: settings,
          results: verses
              .map(
                (v) => VerseSearchResult(
                  verse: v,
                  slices: [
                    SearchSlice(
                      start: 0,
                      end: v.verseText.length,
                      text: v.verseText,
                      match: true,
                    )
                  ],
                ),
              )
              .toList());
    }
    return SearchResult(settings: settings, results: []);
  }
}
