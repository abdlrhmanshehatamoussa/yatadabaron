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
}
