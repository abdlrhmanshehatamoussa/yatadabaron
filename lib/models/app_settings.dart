class AppSettings {
  final bool nightMode;
  final String language;
  final List<int> tarteelLocation;

  AppSettings({
    required this.nightMode,
    required this.language,
    required this.tarteelLocation,
  });

  static AppSettings get empty => AppSettings(
        language: "ar",
        nightMode: false,
        tarteelLocation: [],
      );
}
