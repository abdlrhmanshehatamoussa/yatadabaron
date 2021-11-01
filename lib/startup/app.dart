import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:yatadabaron/commons/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/services/helpers/api_helper.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/services/version_info_service.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/custom_material_app.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'session_manager.dart';

class MyApp extends SimpleApp {
  static const String _ASSETS_DB_NAME = 'quran_usmani.db';
  static const String _ASSETS_DB_DIRECTORY = "assets/data";
  static const String _ASSETS_ENV = 'assets/.env';
  static const String APP_SETTINGS_VERSION = 'VERSION';
  static const String _CLOUDHUB_API_URL = "CLOUDHUB_API_URL";
  static const String _CLOUDHUB_CLIENT_KEY = "CLOUDHUB_CLIENT_KEY";
  static const String _CLOUDHUB_CLIENT_SECRET = "CLOUDHUB_CLIENT_SECRET";
  static const String _CLOUDHUB_APP_GUID = "CLOUDHUB_APP_GUID";
  static const String _TAFSEER_SOURCES_URL = "TAFSEER_SOURCES_URL";
  static const String _TAFSEER_TEXT_URL = "TAFSEER_TEXT_URL";

  @override
  Widget startupErrorWidget(String errorMessage) {
    return Splash(
      child: Text(errorMessage),
      versionLabel: "",
    );
  }

  @override
  Widget app() {
    return StreamBuilder<AppSession>(
      stream: AppSessionManager.instance.stream,
      builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
        if (!sessionSnapshot.hasData) {
          return CustomMaterialApp(
            widget: splashWidget(),
          );
        }
        return CustomMaterialApp(
          widget: HomePage(),
          theme: sessionSnapshot.data!.themeDataWrapper.themeData,
        );
      },
    );
  }

  @override
  Widget splashWidget() {
    return Splash(
      child: LoadingWidget(),
      versionLabel: "",
    );
  }

  @override
  Future<ISimpleServiceProvider> createServiceProvider() async {
    var _pref = await SharedPreferences.getInstance();
    var _info = await PackageInfo.fromPlatform();

    //Configurations
    await dotenv.load(fileName: _ASSETS_ENV);
    Map<String, String> settings = dotenv.env;

    //Initialize database provider
    String databaseFilePath = await DatabaseHelper.initializeDatabase(
      dbAssetsDirectory: _ASSETS_DB_DIRECTORY,
      dbAssetsName: _ASSETS_DB_NAME,
    );

    //Cloud Hub Helper
    CloudHubAPIHelper _cloudHubHelper = CloudHubAPIHelper(
      CloudHubAPIClientInfo(
        apiUrl: settings[_CLOUDHUB_API_URL]!,
        applicationGUID: settings[_CLOUDHUB_APP_GUID]!,
        clientKey: settings[_CLOUDHUB_CLIENT_KEY]!,
        clientSecret: settings[_CLOUDHUB_CLIENT_SECRET]!,
      ),
    );

    List<ISimpleService> services = [
      UserDataService(preferences: _pref),
      ChaptersService(databasePath: databaseFilePath),
      VersesService(databaseFilePath: databaseFilePath),
      TafseerService(tafseerURL: settings[_TAFSEER_TEXT_URL]!),
      ReleaseInfoService(preferences: _pref, apiHelper: _cloudHubHelper),
      AnalyticsService(
        preferences: _pref,
        appVersion: int.tryParse(_info.buildNumber) ?? 0,
        apiHelper: _cloudHubHelper,
      ),
      TafseerSourcesService(
        tafseerSourcesFileURL: settings[_TAFSEER_SOURCES_URL]!,
      ),
      VersionInfoService(
        buildNumber: int.tryParse(_info.buildNumber) ?? 0,
        versionName: _info.version,
      ),
    ];
    return EagerServiceProvider(services);
  }
 

  @override
  Future<void> initialize(
    ISimpleServiceProvider serviceProvider,
  ) async {
    //Load releases
    IReleaseInfoService releaseInfoService =
        serviceProvider.getService<IReleaseInfoService>();

    //Log events
    IAnalyticsService analyticsService =
        serviceProvider.getService<IAnalyticsService>();

    await analyticsService.logAppStarted();
    await analyticsService.syncAllLogs();
    await releaseInfoService.syncReleases();

    //Initialize the session
    IUserDataService userDataService =
        serviceProvider.getService<IUserDataService>();
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
  }
}
