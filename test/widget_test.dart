import 'package:yatadabaron/main_app/services/verses_service.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/search/view_models/colorized_span.dart';

void main() async {
  Verse v = Verse(
    chapterId: 1,
    verseID: 1,
    verseText:
        "سيقولون ثلاثة رابعهم كلبهم ويقولون خمسة سادسهم كلبهم رجما بالغيب ويقولون سبعة وثامنهم كلبهم قل ربي أعلم بعدتهم ما يعلمهم إلا قليل فلا تمار فيهم إلا مراء ظاهرا ولا تستفت فيهم منهم أحدا",
    verseTextTashkel: "",
    chapterName: "",
  );
  SearchSettings settings = SearchSettings(
    basmala: false,
    chapterID: 0,
    keyword: "قول",
    mode: SearchMode.WITHIN,
  );
  VerseSearchResult result = VersesService.buildResultResult(v, settings);
  var splited = ColorizedSpan.splitVerse(result: result);
  print(splited);
}
