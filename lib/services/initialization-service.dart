import 'package:Yatadabaron/services/database-provider.dart';
import 'package:package_info/package_info.dart';
// import 'package:wisebay_essentials/analytics/analytics_helper.dart';

class InitializationService {
  static InitializationService instance = InitializationService._();
  InitializationService._();
  Future<bool> initialize() async {
    try {
      await DatabaseProvider.initialize();
    } catch (e) {
      return false;
    }
    // try {
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   String version = packageInfo.buildNumber;
    //   await AnalyticsHelper.instance.initialize("YATADABARON", version);
    //   await AnalyticsHelper.instance.logEvent(AnalyticsHelper.APP_STARTED);
    //   await AnalyticsHelper.instance.pushEvents();
    // } catch (e) {}
    return true;
  }
}
