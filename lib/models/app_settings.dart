class AppSettings {
  final bool nightMode;
  final String language;
  final String? reciterKey;
  final List<int> tarteelLocation;

  AppSettings({
    required this.nightMode,
    required this.language,
    required this.reciterKey,
    required this.tarteelLocation,
  });

  static AppSettings get empty => AppSettings(
        language: "ar",
        nightMode: false,
        reciterKey: null,
        tarteelLocation: [],
      );
}
