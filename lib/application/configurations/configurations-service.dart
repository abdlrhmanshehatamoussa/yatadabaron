import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';

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

  @override
  String get cloudHubApiUrl => _getKey(_CLOUDHUB_API_URL);

  @override
  String get cloudHubClientKey => _getKey(_CLOUDHUB_CLIENT_KEY);

  @override
  String get cloudHubClientSecret => _getKey(_CLOUDHUB_CLIENT_SECRET);

  @override
  String get cloudHubAppGuid => _getKey(_CLOUDHUB_APP_GUID);

  @override
  String get versionName => _packageInfo.version;

  @override
  int get versionNumber {
    int? number = int.tryParse(_packageInfo.buildNumber);
    if (number != null) {
      return number;
    } else {
      return 0;
    }
  }

  @override
  String get tafseerSourcesURL => _getKey(_TAFSEER_SOURCES_URL);

  @override
  String get tafseerTextURL => _getKey(_TAFSEER_TEXT_URL);

  String _getKey(String key) {
    String? value = dotenv.env[key];
    if (value != null) {
      return value;
    }
    throw new Exception("Error while loading configurations [$key]");
  }

}
