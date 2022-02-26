class ReleaseInfo {
  final String releaseNotes;
  final DateTime releaseDate;
  final String releaseName;

  ReleaseInfo({
    required this.releaseNotes,
    required this.releaseDate,
    required this.releaseName,
  });

  static ReleaseInfo fromJsonRemote(Map<String, dynamic> releasesJson) {
    return ReleaseInfo(
      releaseName: releasesJson["release_name"],
      releaseDate: DateTime.parse(releasesJson["release_date"].toString()),
      releaseNotes: releasesJson["release_notes"],
    );
  }
}
