import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

    //Network detector
    var networkDetectorService = NetworkDetectorService();

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

    await registerPlatformSpecificDependencies(_pref);
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

Future<void> registerPlatformSpecificDependencies(
  SharedPreferences _pref,
) async {
  //ITafseerService
  var tafseerURL = "https://github.com/abdlrhmanshehatamoussa/quran_tafseer";
  Simply.register<ITafseerService>(
    service: kIsWeb
        ? TafseerServiceWeb(
            tafseerURL: tafseerURL,
          )
        : TafseerService(
            tafseerURL: tafseerURL,
            networkDetectorService: NetworkDetectorService(),
          ),
    method: InjectionMethod.singleton,
  );

  //ITafseerSourceService
  if (kIsWeb) {
    Simply.register<ITafseerSourcesService>(
      service: TafseerSourcesServiceWeb(
        localRepo: SharedPrefRepository<TafseerSource>(
          preferences: _pref,
          mapper: TafseerSourceMapper(),
        ),
        remoteRepo: TafseerSourceRemoteRepoWeb(),
        networkDetectorService: NetworkDetectorService(),
      ),
      method: InjectionMethod.singleton,
    );
  } else {
    Simply.register<ITafseerSourcesService>(
      service: TafseerSourcesService(
        localRepo: SharedPrefRepository<TafseerSource>(
          preferences: _pref,
          mapper: TafseerSourceMapper(),
        ),
        remoteRepo: FirebaseRemoteRepository(
          mapper: TafseerSourceMapper(),
          collectionName: "tafseer_sources",
        ),
        networkDetectorService: NetworkDetectorService(),
      ),
      method: InjectionMethod.singleton,
    );
  }

  //IVersionService
  if (kIsWeb) {
    Simply.register<IVersionInfoService>(
      service: VersionInfoService(buildId: "0", versionName: "0.0.0"),
      method: InjectionMethod.singleton,
    );
  } else {
    var _info = await PackageInfo.fromPlatform();
    Simply.register<IVersionInfoService>(
      service: VersionInfoService(
        buildId: _info.buildNumber,
        versionName: _info.version,
      ),
      method: InjectionMethod.singleton,
    );
  }

  //IChapterService + IVerseService
  if (kIsWeb) {
    Simply.register<IChaptersService>(
      service: ChaptersServiceWeb(),
    );
    Simply.register<IVersesService>(
      service: VerseServiceWeb(),
    );
  } else {
    //Initialize database provider
    String databaseFilePath = await DatabaseHelper.initializeDatabase(
      dbAssetsDirectory: Constants.ASSETS_DB_DIRECTORY,
      dbAssetsName: Constants.ASSETS_DB_NAME,
    );
    Simply.register<IChaptersService>(
      service: ChaptersService(databasePath: databaseFilePath),
    );
    Simply.register<IVersesService>(
      service: VersesService(databaseFilePath: databaseFilePath),
    );
  }

  //Audio Downloader
  if (kIsWeb) {
    Simply.register<IVerseAudioDownloader>(
      service: VerseAudioDownloaderWeb(),
    );
  } else {
    var applicationDirectory = (await getApplicationDocumentsDirectory()).path;
    Simply.register<IVerseAudioDownloader>(
      service: VerseAudioDownloader(applicationDirectory),
    );
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
    webRecaptchaSiteKey:
        kReleaseMode ? "" : "AC7307BF-240F-47E3-9F4D-F644F4D284D0",
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
