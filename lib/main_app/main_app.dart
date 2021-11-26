import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/api_helper.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/commons/database_helper.dart';
import 'package:yatadabaron/commons/themes.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'services/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class MainApp extends SimpleApp {
  @override
  Widget startupErrorPage(String errorMessage) {
    return Splash(
      child: Text(errorMessage),
      versionLabel: "",
    );
  }

  @override
  Widget splashPage() {
    return Splash(
      child: LoadingWidget(),
      versionLabel: "",
    );
  }

  @override
  Future<void> registerServices(ISimpleServiceRegistery registery) async {
    var _pref = await SharedPreferences.getInstance();
    var _info = await PackageInfo.fromPlatform();

    //Configurations
    await dotenv.load(fileName: Constants.ASSETS_ENV);
    Map<String, String> settings = dotenv.env;

    //TODO: Validate app settings

    //Initialize database provider
    String databaseFilePath = await DatabaseHelper.initializeDatabase(
      dbAssetsDirectory: Constants.ASSETS_DB_DIRECTORY,
      dbAssetsName: Constants.ASSETS_DB_NAME,
    );

    //Cloud Hub Helper
    CloudHubAPIHelper _cloudHubHelper = CloudHubAPIHelper(
      CloudHubAPIClientInfo(
        apiUrl: settings[Constants.ENV_CLOUDHUB_API_URL]!,
        applicationGUID: settings[Constants.ENV_CLOUDHUB_APP_GUID]!,
        clientKey: settings[Constants.ENV_CLOUDHUB_CLIENT_KEY]!,
        clientSecret: settings[Constants.ENV_CLOUDHUB_CLIENT_SECRET]!,
      ),
    );

    registery.register<IBookmarksService>(
      service: BookmarksService(preferences: _pref),
    );
    registery.register<IChaptersService>(
      service: ChaptersService(databasePath: databaseFilePath),
    );
    registery.register<IVersesService>(
      service: VersesService(databaseFilePath: databaseFilePath),
    );
    registery.register<ITafseerService>(
      service:
          TafseerService(tafseerURL: settings[Constants.ENV_TAFSEER_TEXT_URL]!),
    );
    registery.register<IReleaseInfoService>(
      service: ReleaseInfoService(
        preferences: _pref,
        apiHelper: _cloudHubHelper,
      ),
    );
    registery.register<IAnalyticsService>(
      service: AnalyticsService(
        preferences: _pref,
        appVersion: int.tryParse(_info.buildNumber) ?? 0,
        apiHelper: _cloudHubHelper,
      ),
    );
    registery.register<ITafseerSourcesService>(
      service: TafseerSourcesService(
        tafseerSourcesFileURL: settings[Constants.ENV_TAFSEER_SOURCES_URL]!,
      ),
    );
    registery.register<IVersionInfoService>(
      service: VersionInfoService(
        buildId: _info.buildNumber,
        versionName: _info.version,
      ),
    );

    registery.register<IAppSettingsService>(
      service: AppSettingsService(
        sharedPreferences: _pref,
      ),
    );

    registery.register<IUserService>(
      service: UserService(
        sharedPreferences: _pref,
        cloudHubAPIHelper: _cloudHubHelper
      ),
    );
  }

  @override
  Future<void> onAppStart(ISimpleServiceProvider serviceProvider) async {
    try {
      //Log events
      var analyticsService = serviceProvider.getService<IAnalyticsService>();
      await analyticsService.logAppStarted();
      await analyticsService.syncAllLogs();

      //Load releases
      var releaseInfoService =
          serviceProvider.getService<IReleaseInfoService>();
      await releaseInfoService.syncReleases();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget buildApp(
    ISimpleServiceProvider serviceProvider,
    String payload,
  ) {
    var appSettingsService = serviceProvider.getService<IAppSettingsService>();
    bool isNightMode = appSettingsService.currentValue.nightMode;
    ThemeData theme = isNightMode ? Themes.darkTheme() : Themes.lightTheme();
    return CustomMaterialApp(
      widget: HomePage(),
      theme: theme,
    );
  }
}
