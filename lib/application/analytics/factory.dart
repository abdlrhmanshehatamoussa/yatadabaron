import 'package:Yatadabaron/modules/application.module.dart';
import 'package:package_info/package_info.dart';
import '../cloudhub/api-client-info.dart';
import '../cloudhub/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics-service.dart';
import 'interface.dart';

class AnalyticsServiceFactory {
  static Future<IAnalyticsService> create(
      IConfigurationService _configService) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.buildNumber;
    int? versionInt = int.tryParse(version);
    APIHelper helper = APIHelper(
      new APIClientInfo(
        clientKey: _configService.cloudHubClientKey,
        clientSecret: _configService.cloudHubClientSecret,
        applicationGUID: _configService.cloudHubAppGuid,
        apiUrl: _configService.cloudHubApiUrl,
      ),
    );

    if (versionInt != null) {
      await SharedPreferences.getInstance();
      SharedPreferences pref = await SharedPreferences.getInstance();
      return AnalyticsService(pref, versionInt, helper);
    } else {
      throw new Exception("Error while initializing");
    }
  }
}
