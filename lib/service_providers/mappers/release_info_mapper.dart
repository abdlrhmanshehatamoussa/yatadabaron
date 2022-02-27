import 'dart:convert';
import 'package:yatadabaron/_modules/models.module.dart';
import 'i_mapper.dart';

class ReleaseInfoMapper implements IMapper<ReleaseInfo> {
  static const String _RELEASE_NAME = "release_name";
  static const String _RELEASE_NOTES = "release_notes";
  static const String _RELEASE_DATE = "release_date";

  @override
  ReleaseInfo fromJsonStr(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return new ReleaseInfo(
      releaseName: json[_RELEASE_NAME],
      releaseNotes: json[_RELEASE_NOTES],
      releaseDate: DateTime.parse(json[_RELEASE_DATE]),
    );
  }

  @override
  String toJsonStr(ReleaseInfo obj) {
    Map<String, dynamic> json = new Map();
    json[_RELEASE_NAME] = obj.releaseName;
    json[_RELEASE_NOTES] = obj.releaseNotes;
    json[_RELEASE_DATE] = obj.releaseDate.toString().split('T')[0];
    return jsonEncode(json);
  }
}
