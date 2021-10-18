import 'package:yatadabaron/modules/application.module.dart';

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
      IConfigurationService _configurationService =
          await ConfigurationServiceFactory.create();
      IAnalyticsService _analyticsService =
          await AnalyticsServiceFactory.create(_configurationService);
      IUserDataService _userDataService = await UserDataServiceFactory.create();
      IMushafService _mushafService = await MushafServiceFactory.create();

      TafseerServiceConfigurations tafseerConfig = TafseerServiceConfigurations(
        tafseerSourcesURL: _configurationService.tafseerSourcesURL,
        tafseerTextURL: _configurationService.tafseerTextURL,
      );
      ITafseerService _tafseerService =
          await TafseerServiceFactory.create(tafseerConfig);

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
