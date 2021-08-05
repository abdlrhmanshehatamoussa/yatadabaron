import 'package:Yatadabaron/services/api_helper.dart';
import 'package:Yatadabaron/services/custom-prefs.dart';
import 'package:Yatadabaron/services/database-provider.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics-service.dart';

class InitializationService {
  static InitializationService instance = InitializationService._();
  InitializationService._();

  Future<bool> _initializeDB() async {
    try {
      await DatabaseProvider.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _initializeCustomSharedPref() async {
    try {
      await CustomSharedPreferences.instance.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _initializeAnalyticsService() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      int? versionInt = int.tryParse(version);
      SharedPreferences pref = await SharedPreferences.getInstance();
      APIHelper helper = APIHelper(
        new APIClientInfo(
          clientKey: "ce7c48fc-fcb2-4f0c-be20-2e88e94f380f",
          clientSecret: "6e0260c6-34be-4854-8608-2f9ebcb1084d",
          applicationGUID: "b1f8e781-bb67-459e-b374-0f26b30a93f2",
          apiUrl: "http://api.cloudhub.a1493d002.tech",
        ),
      );

      if (versionInt != null) {
        AnalyticsService.instance = AnalyticsService(pref, versionInt, helper);
        await AnalyticsService.instance.logAppStarted(push: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> initialize() async {
    bool db = await _initializeDB();
    bool shp = await _initializeCustomSharedPref();
    bool anl = await _initializeAnalyticsService();
    return (db && shp && anl);
  }
}
