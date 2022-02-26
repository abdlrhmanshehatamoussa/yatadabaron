class AppSettings {
  final bool nightMode;
  final String language;

  AppSettings({
    required this.nightMode,
    required this.language,
  });

  static AppSettings get empty => AppSettings(
        language: "ar",
        nightMode: false,
      );
}
