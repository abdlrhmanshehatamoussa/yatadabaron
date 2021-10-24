import 'package:yatadabaron/models/module.dart';

class ConfigurationManager {
  ConfigurationManager({
    required this.configurationValues,
    required this.versionName,
    required this.buildNumber,
  });

  final String versionName;
  final int buildNumber;
  final Map<String, String> configurationValues;

  static const String _CLOUDHUB_API_URL = "CLOUDHUB_API_URL";
  static const String _CLOUDHUB_CLIENT_KEY = "CLOUDHUB_CLIENT_KEY";
  static const String _CLOUDHUB_CLIENT_SECRET = "CLOUDHUB_CLIENT_SECRET";
  static const String _CLOUDHUB_APP_GUID = "CLOUDHUB_APP_GUID";
  static const String _TAFSEER_SOURCES_URL = "TAFSEER_SOURCES_URL";
  static const String _TAFSEER_TEXT_URL = "TAFSEER_TEXT_URL";

  String _getKey(String key) {
    String? value = configurationValues[key];
    if (value != null) {
      return value;
    }
    throw new Exception("Error while loading configurations [$key]");
  }

  Future<AppSettings> getAppSettings() async {
    String cloudHubApiUrl = _getKey(_CLOUDHUB_API_URL);
    String cloudHubClientKey = _getKey(_CLOUDHUB_CLIENT_KEY);
    String cloudHubClientSecret = _getKey(_CLOUDHUB_CLIENT_SECRET);
    String cloudHubAppGuid = _getKey(_CLOUDHUB_APP_GUID);
    String versionName = this.versionName;
    String tafseerSourcesURL = _getKey(_TAFSEER_SOURCES_URL);
    String tafseerTextURL = _getKey(_TAFSEER_TEXT_URL);
    int versionNumber = this.buildNumber;
    return AppSettings(
      cloudHubApiUrl: cloudHubApiUrl,
      cloudHubAppGuid: cloudHubAppGuid,
      versionName: versionName,
      cloudHubClientKey: cloudHubClientKey,
      cloudHubClientSecret: cloudHubClientSecret,
      tafseerSourcesURL: tafseerSourcesURL,
      tafseerTextURL: tafseerTextURL,
      versionNumber: versionNumber,
    );
  }
}
