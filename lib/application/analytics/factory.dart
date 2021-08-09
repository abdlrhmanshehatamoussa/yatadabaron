import 'package:Yatadabaron/modules/application.module.dart';
import '../cloudhub/api-client-info.dart';
import '../cloudhub/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics-service.dart';
import 'interface.dart';

class AnalyticsServiceFactory {
  static Future<IAnalyticsService> create(
    IConfigurationService _configService,
  ) async {
    CloudHubAPIClientInfo _info = new CloudHubAPIClientInfo(
      clientKey: _configService.cloudHubClientKey,
      clientSecret: _configService.cloudHubClientSecret,
      applicationGUID: _configService.cloudHubAppGuid,
      apiUrl: _configService.cloudHubApiUrl,
    );
    CloudHubAPIHelper helper = CloudHubAPIHelper(_info);
    await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    return AnalyticsService(pref, _configService.versionNumber, helper);
  }
}
