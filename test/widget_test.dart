import 'package:yatadabaron/main_app/services/verses_service.dart';
import 'package:yatadabaron/models/module.dart';

void main() async {
  String text =
      "سيقولون ثلاثة رابعهم كلبهم ويقولون خمسة سادسهم كلبهم رجما بالغيب ويقولون سبعة وثامنهم كلبهم قل ربي أعلم بعدتهم ما يعلمهم إلا قليل فلا تمار فيهم إلا مراء ظاهرا ولا تستفت فيهم منهم أحدا";
  VersesService service = VersesService(
    databaseFilePath: "",
  );
  List<SearchSlice> slices = service.search(text, " منهم ");
  print(slices);
}
