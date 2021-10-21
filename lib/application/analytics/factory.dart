import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cloudhub/api-client-info.dart';
import '../cloudhub/api_helper.dart';
import 'analytics-service.dart';
import 'interface.dart';

class AnalyticsServiceFactory {
  static Future<IAnalyticsService> create(
    AppSettings appSettings,
    SharedPreferences pref,
  ) async {
    CloudHubAPIClientInfo _info = new CloudHubAPIClientInfo(
      clientKey: appSettings.cloudHubClientKey,
      clientSecret: appSettings.cloudHubClientSecret,
      applicationGUID: appSettings.cloudHubAppGuid,
      apiUrl: appSettings.cloudHubApiUrl,
    );
    CloudHubAPIHelper helper = CloudHubAPIHelper(_info);
    return AnalyticsService(pref, appSettings.versionNumber, helper);
  }
}
