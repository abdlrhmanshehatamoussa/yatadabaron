import 'dart:convert';

class ReleaseInfo {
  final String releaseNotes;
  final DateTime releaseDate;
  final String releaseName;

  ReleaseInfo({
    required this.releaseNotes,
    required this.releaseDate,
    required this.releaseName,
  });

  String toJson() {
    Map<String, dynamic> map = Map();
    map["release_name"] = this.releaseName;
    map["release_date"] = releaseDate.toString().split('T')[0];
    map["release_notes"] = this.releaseNotes;
    return jsonEncode(map);
  }

  static ReleaseInfo fromJson(Map<String, dynamic> releasesJson) {
    return ReleaseInfo(
      releaseName: releasesJson["release_name"],
      releaseDate: DateTime.parse(releasesJson["release_date"].toString()),
      releaseNotes: releasesJson["release_notes"],
    );
  }
}
