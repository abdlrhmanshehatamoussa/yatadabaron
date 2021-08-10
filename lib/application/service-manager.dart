import 'package:Yatadabaron/modules/application.module.dart';

class ServiceManager {
  final IMushafService mushafService;
  final IConfigurationService configurationService;
  final IUserDataService userDataService;
  final IAnalyticsService analyticsService;

  ServiceManager._({
    required this.mushafService,
    required this.configurationService,
    required this.userDataService,
    required this.analyticsService,
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
    IConfigurationService _configurationService =
        await ConfigurationServiceFactory.create();
    IAnalyticsService _analyticsService =
        await AnalyticsServiceFactory.create(_configurationService);
    IUserDataService _userDataService = await UserDataServiceFactory.create();
    IMushafService _mushafService = await MushafServiceFactory.create();

    ServiceManager.instance = ServiceManager._(
      mushafService: _mushafService,
      configurationService: _configurationService,
      userDataService: _userDataService,
      analyticsService: _analyticsService,
    );
    return true;
  }
}
