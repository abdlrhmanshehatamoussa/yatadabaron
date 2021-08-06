import 'package:Yatadabaron/services/api_helper.dart';
import 'package:Yatadabaron/services/configurations-service.dart';
import 'package:Yatadabaron/repositories/userdata-repository.dart';
import 'package:Yatadabaron/services/database-provider.dart';
import 'package:package_info/package_info.dart';
import 'analytics-service.dart';

class InitializationService {
  static InitializationService instance = InitializationService._();
  InitializationService._();

  Future<bool> initialize() async {
    bool db = await DatabaseProvider.initialize();
    bool shp = await UserDataRepository.instance.initialize();
    bool conf = await ConfigurationService.instance.initialize();
    bool anl = await _initializeAnalyticsService();
    return (db && shp && conf && anl);
  }

  Future<bool> _initializeAnalyticsService() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      int? versionInt = int.tryParse(version);
      APIHelper helper = APIHelper(
        new APIClientInfo(
          clientKey: ConfigurationService.instance.cloudHubClientKey,
          clientSecret: ConfigurationService.instance.cloudHubClientSecret,
          applicationGUID: ConfigurationService.instance.cloudHubAppGuid,
          apiUrl: ConfigurationService.instance.cloudHubApiUrl,
        ),
      );

      if (versionInt != null) {
        AnalyticsService.instance = AnalyticsService(versionInt, helper);
        await AnalyticsService.instance.logAppStarted(push: true);
        return true;
      }
      return false;
    } catch (e) {
      print("Error while intiailizing analytics service: $e");
      return false;
    }
  }
}
