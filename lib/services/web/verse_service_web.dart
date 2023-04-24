import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class VerseServiceWeb extends IVersesService {
  @override
  Future<List<LetterFrequency>> getLetterFrequency(
      BasicSearchSettings settings) async {
    return [];
  }

  @override
  Future<Verse> getSingleVerse(int verseId, int chapterId) async {
    var response = await get(Uri.parse(
        "https://api.alquran.cloud/v1/ayah/$chapterId:$verseId/quran-usmani"));
    var body = jsonDecode(response.body);
    return Verse(
        chapterId: chapterId,
        verseID: verseId,
        verseText: body["data"]["text"],
        verseTextTashkel: body["data"]["text"],
        chapterName: body["data"]["surah"]["name"]);
  }

  @override
  Future<List<Verse>> getVersesByChapterId(int? chapterId, bool basmala) async {
    var url = "http://api.alquran.cloud/v1/surah/$chapterId/quran-usmani";
    var response = await get(Uri.parse(url));
    var body = jsonDecode(response.body);
    var result = <Verse>[];
    for (var element in body["data"]["ayahs"]) {
      result.add(Verse(
        chapterId: chapterId ?? 0,
        verseID: element["numberInSurah"],
        verseText: element["text"],
        verseTextTashkel: element["text"],
        chapterName: body["data"]["name"],
      ));
    }
    return result;
  }

  @override
  Future<SearchResult> keywordSearch(KeywordSearchSettings settings) async {
    return SearchResult(settings: settings, results: []);
  }
}
