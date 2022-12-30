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
import 'commons/localization.dart';
import 'firebase_options.dart';

class MainApp extends SimpleMaterialApp {
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
  Future<void> initialize() async {
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

    Simply.register<IEventLogger>(
      service: EventLogger(
        sharedPreferences: _pref,
        versionInfoService: versionService,
      ),
      method: InjectionMethod.singleton,
    );

    Simply.register<INetworkDetectorService>(
      service: networkDetectorService,
      method: InjectionMethod.singleton,
    );

    Simply.register<IBookmarksService>(
      service: BookmarksService(
        repository: new SharedPrefRepository<Bookmark>(
          preferences: _pref,
          mapper: BookmarksMapper(),
        ),
      ),
      method: InjectionMethod.singleton,
    );
    Simply.register<IChaptersService>(
      service: ChaptersService(databasePath: databaseFilePath),
    );
    Simply.register<IVersesService>(
      service: VersesService(databaseFilePath: databaseFilePath),
    );
    Simply.register<ITafseerService>(
      service: TafseerService(
        tafseerURL: "https://github.com/abdlrhmanshehatamoussa/quran_tafseer",
        networkDetectorService: networkDetectorService,
      ),
      method: InjectionMethod.singleton,
    );
    Simply.register<IReleaseInfoService>(
      service: ReleaseInfoService(
        localRepository: new SharedPrefRepository(
          preferences: _pref,
          mapper: new ReleaseInfoMapper(),
        ),
        remoteRepository: new FirebaseRemoteRepository<ReleaseInfo>(
          mapper: new ReleaseInfoMapper(),
          collectionName: "releases",
        ),
        networkDetector: networkDetectorService,
      ),
      method: InjectionMethod.singleton,
    );
    Simply.register<ITafseerSourcesService>(
      service: TafseerSourcesService(
        localRepo: new SharedPrefRepository<TafseerSource>(
          preferences: _pref,
          mapper: new TafseerSourceMapper(),
        ),
        remoteRepo: new FirebaseRemoteRepository(
          mapper: new TafseerSourceMapper(),
          collectionName: "tafseer_sources",
        ),
        networkDetectorService: networkDetectorService,
      ),
      method: InjectionMethod.singleton,
    );
    Simply.register<IVersionInfoService>(
      service: versionService,
      method: InjectionMethod.singleton,
    );

    Simply.register<IAppSettingsService>(
      service: AppSettingsService(
        sharedPreferences: _pref,
      ),
      method: InjectionMethod.singleton,
    );

    try {
      //Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
      );

      var networkDetector = Simply.get<INetworkDetectorService>();
      bool isOnline = await networkDetector.isOnline();
      if (isOnline == false) return;
      var eventLogger = Simply.get<IEventLogger>();

      //Log events
      await eventLogger.logAppStarted().defaultNetworkTimeout();
      await eventLogger.pushEvents().defaultNetworkTimeout();

      //Load releases
      var releaseInfoService = Simply.get<IReleaseInfoService>();
      await releaseInfoService.syncReleases();
    } catch (e) {
      print(e);
    }
  }

  @override
  MaterialApp buildApp(String payload, GlobalKey<NavigatorState> navigatorKey) {
    var appSettingsService = Simply.get<IAppSettingsService>();
    bool isNightMode = appSettingsService.currentValue.nightMode;
    ThemeData theme = isNightMode ? Themes.darkTheme() : Themes.lightTheme();
    return MaterialApp(
      navigatorKey: navigatorKey,
      key: UniqueKey(),
      theme: theme,
      builder: (BuildContext context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      title: Localization.APP_TITLE,
      home: HomePage(),
    );
  }
}
