import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

    //Initialize database provider
    String databaseFilePath = await DatabaseHelper.initializeDatabase(
      dbAssetsDirectory: Constants.ASSETS_DB_DIRECTORY,
      dbAssetsName: Constants.ASSETS_DB_NAME,
    );

    //Network detector
    var networkDetectorService = NetworkDetectorService();
    var versionService = VersionInfoService(
      buildId: _info.version,
      versionName: "8.04",
    );

    registery.register<IEventLogger>(
      service: EventLogger(
        sharedPreferences: _pref,
        versionInfoService: versionService,
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
        tafseerURL: "https://github.com/abdlrhmanshehatamoussa/quran_tafseer",
        networkDetectorService: networkDetectorService,
      ),
    );
    registery.register<IReleaseInfoService>(
      service: ReleaseInfoService(
          localRepository: new SharedPrefRepository(
            preferences: _pref,
            mapper: new ReleaseInfoMapper(),
          ),
          remoteRepository: new FirebaseRemoteRepository<ReleaseInfo>(
            mapper: new ReleaseInfoMapper(),
            collectionName: "releases",
          ),
          networkDetector: networkDetectorService),
    );
    registery.register<ITafseerSourcesService>(
      service: TafseerSourcesService(
          localRepo: new SharedPrefRepository<TafseerSource>(
            preferences: _pref,
            mapper: new TafseerSourceMapper(),
          ),
          remoteRepo: new FirebaseRemoteRepository(
            mapper: new TafseerSourceMapper(),
            collectionName: "tafseer_sources",
          ),
          networkDetectorService: networkDetectorService),
    );
    registery.register<IVersionInfoService>(
      service: versionService,
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
      //Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
      );

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
