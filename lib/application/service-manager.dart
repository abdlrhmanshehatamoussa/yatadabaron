import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';

class ServiceManager {
  final IMushafService mushafService;
  final IConfigurationService configurationService;
  final IUserDataService userDataService;
  final IAnalyticsService analyticsService;
  final ITafseerService tafseerService;
  final IReleaseInfoService releaseInfoService;

  ServiceManager._({
    required this.mushafService,
    required this.configurationService,
    required this.userDataService,
    required this.analyticsService,
    required this.tafseerService,
    required this.releaseInfoService,
  });

  static ServiceManager? _instance;

  static ServiceManager get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw new Exception("Service manager not initialized");
    }
  }

  static set instance(ServiceManager instance) {
    if (_instance == null) {
      _instance = instance;
    }
  }

  static Future<bool> initialize() async {
    try {
      await SharedPreferences.getInstance();
      SharedPreferences pref = await SharedPreferences.getInstance();

      //Configurations Service
      IConfigurationService _configurationService =
          await ConfigurationServiceFactory.create();
      AppSettings appSettings = await _configurationService.getAppSettings();

      //Analytics Service
      IAnalyticsService _analyticsService =
          await AnalyticsServiceFactory.create(appSettings, pref);

      //UserData Service
      IUserDataService _userDataService = await UserDataServiceFactory.create();

      //Mushaf Service
      IMushafService _mushafService = await MushafServiceFactory.create();

      //Tafseer Service
      TafseerServiceConfigurations tafseerConfig = TafseerServiceConfigurations(
        tafseerSourcesURL: appSettings.tafseerSourcesURL,
        tafseerTextURL: appSettings.tafseerTextURL,
      );
      ITafseerService _tafseerService =
          await TafseerServiceFactory.create(tafseerConfig);

      //Release Info Service
      IReleaseInfoService _releaseInfoService =
          await ReleaseInfoServiceFactory.create();

      ServiceManager.instance = ServiceManager._(
          mushafService: _mushafService,
          configurationService: _configurationService,
          userDataService: _userDataService,
          analyticsService: _analyticsService,
          tafseerService: _tafseerService,
          releaseInfoService: _releaseInfoService);
      return true;
    } catch (e) {
      return false;
    }
  }
}
