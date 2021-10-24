import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/commons/database_helper.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'config/page_router.dart';
import 'config/service_provider.dart';
import 'config/session_manager.dart';

class AppController extends BaseController {
  static const String ASSETS_DB_NAME = 'quran_usmani.db';
  static const String ASSETS_DB_DIRECTORY = "assets/data";
  static const String ASSETS_ENV = 'assets/.env';

  Future<String> getVersionLabel() async {
    var _info = await PackageInfo.fromPlatform();
    return Utils.getversionLabel(_info.version, _info.buildNumber);
  }

  Future<bool> start() async {
    try {
      var _pref = await SharedPreferences.getInstance();
      var _info = await PackageInfo.fromPlatform();

      //Initialize database provider
      String databaseFilePath = await DatabaseHelper.initializeDatabase(
        dbAssetsDirectory: ASSETS_DB_DIRECTORY,
        dbAssetsName: ASSETS_DB_NAME,
      );

      //Initialize App Settings
      await dotenv.load(fileName: ASSETS_ENV);
      AppSettings appSettings = AppSettings.fromMap(
        versionName: _info.version,
        buildNumber: int.tryParse(_info.buildNumber) ?? 0,
        configurationValues: dotenv.env,
        dbFilePath: databaseFilePath,
      );

      //Intializate service manager
      ServiceProvider serviceProvider = ServiceProvider(
        preferences: _pref,
        settings: appSettings,
      );

      //Initialize the navigation manager
      PageRouter.instance = PageRouter(
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
