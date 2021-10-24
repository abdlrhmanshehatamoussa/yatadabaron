import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/helpers/database-provider.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'page_manager.dart';
import 'service_provider.dart';
import 'session_manager.dart';

class AppController extends BaseController {
  SharedPreferences? _sharedPreferences;
  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences!;
  }

  PackageInfo? _packageInfo;
  Future<PackageInfo> get packageInfo async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }
    return _packageInfo!;
  }

  Future<String> getVersionLabel() async {
    var _info = await packageInfo;
    return Utils.getversionLabel(_info.version, _info.buildNumber);
  }

  Future<bool> start() async {
    try {
      var _pref = await sharedPreferences;
      var _info = await packageInfo;
      
      //Initialize App Settings
      await dotenv.load(fileName: 'assets/.env');
      AppSettings appSettings = AppSettings.fromMap(
        versionName: _info.version,
        buildNumber: int.tryParse(_info.buildNumber) ?? 0,
        configurationValues: dotenv.env,
      );

      //Intializate service manager
      ServiceProvider serviceProvider = ServiceProvider(
        preferences: _pref,
        settings: appSettings,
      );

      //Initialize database provider
      //TODO: Change database intialization technique
      await DatabaseProvider.initialize();

      //Initialize the navigation manager
      PageManager.instance = PageManager(
        serviceProvider: serviceProvider,
        appSettings: appSettings,
      );

      IAnalyticsService analyticsService =
          serviceProvider.getService<IAnalyticsService>();
      IUserDataService userDataService =
          serviceProvider.getService<IUserDataService>();

      //Log events
      await analyticsService.logAppStarted();
      await analyticsService.syncAllLogs();

      //Initialize the session
      bool? isNightMode = await userDataService.getNightMode();
      switch (isNightMode) {
        case null:
        case true:
          AppSessionManager.instance.updateTheme(ThemeDataWrapper.dark());
          break;
        case false:
          AppSessionManager.instance.updateTheme(ThemeDataWrapper.light());
          break;
        default:
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
