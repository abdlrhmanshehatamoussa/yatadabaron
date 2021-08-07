import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigurationService {
  static ConfigurationService instance = ConfigurationService._();
  static const String _CLOUDHUB_API_URL = "CLOUDHUB_API_URL";
  static const String _CLOUDHUB_CLIENT_KEY = "CLOUDHUB_CLIENT_KEY";
  static const String _CLOUDHUB_CLIENT_SECRET = "CLOUDHUB_CLIENT_SECRET";
  static const String _CLOUDHUB_APP_GUID = "CLOUDHUB_APP_GUID";

  //Private Constructor
  ConfigurationService._();

  //Initialize
  Future<bool> initialize() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      return true;
    } catch (e) {
      return false;
    }
  }

  String get cloudHubApiUrl => _getKey(_CLOUDHUB_API_URL);
  String get cloudHubClientKey => _getKey(_CLOUDHUB_CLIENT_KEY);
  String get cloudHubClientSecret => _getKey(_CLOUDHUB_CLIENT_SECRET);
  String get cloudHubAppGuid => _getKey(_CLOUDHUB_APP_GUID);

  String _getKey(String key) {
    String? value = dotenv.env[key];
    if (value != null) {
      return value;
    }
    throw new Exception("Error while loading configurations [$key]");
  }
}
