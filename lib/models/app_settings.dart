class AppSettings {
  final bool nightMode;
  final String language;
  final String? reciterKey;

  AppSettings({
    required this.nightMode,
    required this.language,
    required this.reciterKey,
  });

  static AppSettings get empty => AppSettings(
        language: "ar",
        nightMode: false,
        reciterKey: null,
      );
}
