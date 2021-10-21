import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:yatadabaron/domain/models/app_settings.dart';

import 'interface.dart';

class ConfigurationService implements IConfigurationService {
  ConfigurationService(this._packageInfo);

  static const String _CLOUDHUB_API_URL = "CLOUDHUB_API_URL";
  static const String _CLOUDHUB_CLIENT_KEY = "CLOUDHUB_CLIENT_KEY";
  static const String _CLOUDHUB_CLIENT_SECRET = "CLOUDHUB_CLIENT_SECRET";
  static const String _CLOUDHUB_APP_GUID = "CLOUDHUB_APP_GUID";
  static const String _TAFSEER_SOURCES_URL = "TAFSEER_SOURCES_URL";
  static const String _TAFSEER_TEXT_URL = "TAFSEER_TEXT_URL";

  final PackageInfo _packageInfo;

  String _getKey(String key) {
    String? value = dotenv.env[key];
    if (value != null) {
      return value;
    }
    throw new Exception("Error while loading configurations [$key]");
  }

  @override
  Future<AppSettings> getAppSettings() async {
    String cloudHubApiUrl = _getKey(_CLOUDHUB_API_URL);
    String cloudHubClientKey = _getKey(_CLOUDHUB_CLIENT_KEY);
    String cloudHubClientSecret = _getKey(_CLOUDHUB_CLIENT_SECRET);
    String cloudHubAppGuid = _getKey(_CLOUDHUB_APP_GUID);
    String versionName = _packageInfo.version;
    String tafseerSourcesURL = _getKey(_TAFSEER_SOURCES_URL);
    String tafseerTextURL = _getKey(_TAFSEER_TEXT_URL);
    int versionNumber = int.tryParse(_packageInfo.buildNumber) ?? 0;
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
