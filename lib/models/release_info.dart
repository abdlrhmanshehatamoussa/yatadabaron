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

  static ReleaseInfo fromJson(Map<String, dynamic> releasesJson) {
    return ReleaseInfo(
      build: releasesJson["build"],
      minor: releasesJson["minor"],
      major: releasesJson["major"],
      releaseDate: DateTime.parse(releasesJson["created_on"]),
      releaseNotes: releasesJson["release_notes"],
    );
  }
}
