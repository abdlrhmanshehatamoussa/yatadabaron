class AppSettings {
  static const String _CLOUDHUB_API_URL = "CLOUDHUB_API_URL";
  static const String _CLOUDHUB_CLIENT_KEY = "CLOUDHUB_CLIENT_KEY";
  static const String _CLOUDHUB_CLIENT_SECRET = "CLOUDHUB_CLIENT_SECRET";
  static const String _CLOUDHUB_APP_GUID = "CLOUDHUB_APP_GUID";
  static const String _TAFSEER_SOURCES_URL = "TAFSEER_SOURCES_URL";
  static const String _TAFSEER_TEXT_URL = "TAFSEER_TEXT_URL";

  final String cloudHubApiUrl;
  final String cloudHubClientKey;
  final String cloudHubClientSecret;
  final String cloudHubAppGuid;
  final String versionName;
  final String tafseerSourcesURL;
  final String tafseerTextURL;
  final int versionNumber;
  final String databaseFilePath;

  AppSettings({
    required this.cloudHubApiUrl,
    required this.cloudHubClientKey,
    required this.cloudHubClientSecret,
    required this.cloudHubAppGuid,
    required this.versionName,
    required this.tafseerSourcesURL,
    required this.tafseerTextURL,
    required this.versionNumber,
    required this.databaseFilePath,
  });

  static AppSettings fromMap({
    required Map<String, dynamic> configurationValues,
    required String versionName,
    required int buildNumber,
    required String dbFilePath,
  }) {
    String _getKey(String key) {
      String? value = configurationValues[key];
      if (value != null) {
        return value;
      }
      throw new Exception("Error while loading configurations [$key]");
    }

    String cloudHubApiUrl = _getKey(_CLOUDHUB_API_URL);
    String cloudHubClientKey = _getKey(_CLOUDHUB_CLIENT_KEY);
    String cloudHubClientSecret = _getKey(_CLOUDHUB_CLIENT_SECRET);
    String cloudHubAppGuid = _getKey(_CLOUDHUB_APP_GUID);
    String tafseerSourcesURL = _getKey(_TAFSEER_SOURCES_URL);
    String tafseerTextURL = _getKey(_TAFSEER_TEXT_URL);
    return AppSettings(
      cloudHubApiUrl: cloudHubApiUrl,
      cloudHubAppGuid: cloudHubAppGuid,
      versionName: versionName,
      cloudHubClientKey: cloudHubClientKey,
      cloudHubClientSecret: cloudHubClientSecret,
      tafseerSourcesURL: tafseerSourcesURL,
      tafseerTextURL: tafseerTextURL,
      versionNumber: buildNumber,
      databaseFilePath: dbFilePath,
    );
  }
}
