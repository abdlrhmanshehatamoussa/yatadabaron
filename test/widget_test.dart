import 'package:yatadabaron/models/module.dart';

void main() async {
  Verse v = Verse(
    chapterId: 1,
    verseID: 1,
    verseText:"سيقولون ثلاثة رابعهم كلبهم ويقولون خمسة سادسهم كلبهم رجما بالغيب ويقولون سبعة وثامنهم كلبهم قل ربي أعلم بعدتهم ما يعلمهم إلا قليل فلا تمار فيهم إلا مراء ظاهرا ولا تستفت فيهم منهم أحدا",
    verseTextTashkel: "",
    chapterName: "",
  );
  int result = v.countKeyword("كلب", SearchMode.WITHIN);
  print(result);
}
