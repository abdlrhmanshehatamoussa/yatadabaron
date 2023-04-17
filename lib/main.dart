import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/commons/database_helper.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_providers.module.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import 'commons/localization.dart';
import 'commons/themes.dart';
import 'firebase_options.dart';
import 'global.dart';
import 'pages/home/view.dart';

export 'global.dart';

final StreamObject<String> _simpleStream = StreamObject(initialValue: "");
Stream<String> get _reloadStream => _simpleStream.stream;
GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Function(String) get appReload => (payload) => _simpleStream.add(payload);
NavigatorState get appNavigator => _navigatorKey.currentState!;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    FutureBuilder<bool>(
      future: register(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return splashApp();
        if (snapshot.data! == false)
          return errorApp(Localization.LOADING_ERROR);
        return StreamBuilder<String>(
          stream: _reloadStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return splashApp();
            if (snapshot.hasError) return errorApp(snapshot.error);
            return buildApp();
          },
        );
      },
    ),
  );
}

MaterialApp splashApp() => MaterialApp(
      home: Splash(
        child: LoadingWidget(),
        versionLabel: "",
      ),
    );

MaterialApp errorApp(errorMessage) => MaterialApp(
      home: Splash(
        child: Text(errorMessage),
        versionLabel: "",
      ),
    );

Widget buildApp() {
  var appSettingsService = Simply.get<IAppSettingsService>();
  bool isNightMode = appSettingsService.currentValue.nightMode;
  ThemeData theme = isNightMode ? Themes.darkTheme() : Themes.lightTheme();
  return MaterialApp(
    navigatorKey: _navigatorKey,
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

Future<bool> register() async {
  try {
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
        buildId: _info.buildNumber, versionName: _info.version);

    Simply.register<IEventLogger>(
      service: EventLogger(),
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

    Simply.register<IMutedMessagesService>(
      method: InjectionMethod.scoped,
      service: MutedMessages(sharedPreferences: _pref),
    );
    await init();
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> init() async {
  //Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
  );

  try {
    //Log events
    var eventLogger = Simply.get<IEventLogger>();
    await eventLogger.logAppStarted();

    //Sync online data
    var networkDetector = Simply.get<INetworkDetectorService>();
    bool isOnline = await networkDetector.isOnline();
    if (isOnline) {
      var releaseInfoService = Simply.get<IReleaseInfoService>();
      await releaseInfoService.syncReleases();

      var tafseerSourcesService = Simply.get<ITafseerSourcesService>();
      await tafseerSourcesService.syncTafseerSources();
    }
  } catch (e) {
    print("Initialization error, ${e.toString()}");
  }
}
