import 'dart:convert';
import 'package:yatadabaron/_modules/models.module.dart';
import 'i_mapper.dart';

class TafseerSourceMapper implements IMapper<TafseerSource> {
  @override
  TafseerSource fromJsonStr(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return new TafseerSource(
      tafseerId: json["tafseer_id"],
      tafseerName: json["tafseer_name"],
      tafseerNameEnglish: json["tafseer_name_en"],
    );
  }

  @override
  String toJsonStr(TafseerSource obj) {
    Map<String, dynamic> json = new Map();
    json["tafseer_id"] = obj.tafseerId;
    json["tafseer_name"] = obj.tafseerName;
    json["tafseer_name_en"] = obj.tafseerNameEnglish;
    return jsonEncode(json);
  }

  @override
  bool isIdentical(TafseerSource obj, TafseerSource obj2) {
    return obj.tafseerId == obj2.tafseerId;
  }
}
