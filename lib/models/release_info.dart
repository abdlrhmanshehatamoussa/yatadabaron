import 'dart:convert';

class ReleaseInfo {
  final String releaseNotes;
  final DateTime releaseDate;
  final int major;
  final int minor;
  final int build;

  ReleaseInfo({
    required this.major,
    required this.minor,
    required this.build,
    required this.releaseNotes,
    required this.releaseDate,
  });

  String get uniqueId {
    return "$major.$minor.$build";
  }

  String toJson() {
    Map<String, dynamic> map = Map();
    map["major"] = this.major;
    map["minor"] = this.minor;
    map["build"] = this.build;
    map["release_date"] = releaseDate.toString().split('T')[0];
    map["release_notes"] = this.releaseNotes;
    return jsonEncode(map);
  }

  static ReleaseInfo fromJson(Map<String, dynamic> releasesJson) {
    return ReleaseInfo(
      build: releasesJson["build"],
      minor: releasesJson["minor"],
      major: releasesJson["major"],
      releaseDate: DateTime.parse(releasesJson["release_date"].toString()),
      releaseNotes: releasesJson["release_notes"],
    );
  }
}
