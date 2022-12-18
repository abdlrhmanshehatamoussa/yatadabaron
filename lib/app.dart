import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/commons/database_helper.dart';
import 'package:yatadabaron/commons/extensions.dart';
import 'package:yatadabaron/commons/themes.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/_modules/service_providers.module.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';

import 'firebase_options.dart';

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

    if (!settings.containsKey(Constants.ENV_CLOUDHUB_API_URL) ||
        !settings.containsKey(Constants.ENV_CLOUDHUB_CLIENT_KEY) ||
        !settings.containsKey(Constants.ENV_CLOUDHUB_CLIENT_SECRET) ||
        !settings.containsKey(Constants.ENV_TAFSEER_TEXT_URL)) {
      throw Exception("Initialization Error - Missing environment variable");
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Initialize database provider
    String databaseFilePath = await DatabaseHelper.initializeDatabase(
      dbAssetsDirectory: Constants.ASSETS_DB_DIRECTORY,
      dbAssetsName: Constants.ASSETS_DB_NAME,
    );

    //Network detector
    var networkDetectorService = NetworkDetectorService();

    registery.register<IEventLogger>(
      service: EventLogger(
        sharedPreferences: _pref,
        buildId: _info.buildNumber,
      ),
    );

    registery.register<INetworkDetectorService>(
      service: networkDetectorService,
    );

    registery.register<IBookmarksService>(
      service: BookmarksService(
        repository: new SharedPrefRepository<Bookmark>(
          preferences: _pref,
          mapper: BookmarksMapper(),
        ),
      ),
    );
    registery.register<IChaptersService>(
      service: ChaptersService(databasePath: databaseFilePath),
    );
    registery.register<IVersesService>(
      service: VersesService(databaseFilePath: databaseFilePath),
    );
    registery.register<ITafseerService>(
      service: TafseerService(
        tafseerURL: settings[Constants.ENV_TAFSEER_TEXT_URL]!,
        networkDetectorService: networkDetectorService,
      ),
    );
    registery.register<IReleaseInfoService>(
      service: ReleaseInfoService(
          localRepository: new SharedPrefRepository(
            preferences: _pref,
            mapper: new ReleaseInfoMapper(),
          ),
          networkDetector: networkDetectorService),
    );
    registery.register<ITafseerSourcesService>(
      service: TafseerSourcesService(
          localRepo: new SharedPrefRepository<TafseerSource>(
            preferences: _pref,
            mapper: new TafseerSourceMapper(),
          ),
          networkDetectorService: networkDetectorService),
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
  }

  @override
  Future<void> onAppStart(ISimpleServiceProvider serviceProvider) async {
    try {
      var networkDetector =
          serviceProvider.getService<INetworkDetectorService>();
      bool isOnline = await networkDetector.isOnline();
      if (isOnline == false) return;
      var eventLogger = serviceProvider.getService<IEventLogger>();

      //Log events
      await eventLogger.logAppStarted().defaultNetworkTimeout();
      await eventLogger.pushEvents().defaultNetworkTimeout();

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
