import 'dart:convert';
import 'package:yatadabaron/_modules/models.module.dart';
import 'i_mapper.dart';

class TafseerSourceMapper implements IMapper<TafseerSource> {
  static const String _TAFSEER_ID = "tafseer_id";
  static const String _TAFSEER_NAME = "tafseer_name";
  static const String _TAFSEER_NAME_EN = "tafseer_name_en";

  @override
  TafseerSource fromJsonStr(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return new TafseerSource(
      tafseerId: json[_TAFSEER_ID],
      tafseerName: json[_TAFSEER_NAME],
      tafseerNameEnglish: json[_TAFSEER_NAME_EN],
    );
  }

  @override
  String toJsonStr(TafseerSource obj) {
    Map<String, dynamic> json = new Map();
    json[_TAFSEER_ID] = obj.tafseerId;
    json[_TAFSEER_NAME] = obj.tafseerName;
    json[_TAFSEER_NAME_EN] = obj.tafseerNameEnglish;
    return jsonEncode(json);
  }
}
