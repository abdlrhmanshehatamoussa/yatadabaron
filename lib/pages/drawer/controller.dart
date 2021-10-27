import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/app/config/session_manager.dart';

class CustomDrawerController extends BaseController {
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;
  final AppSettings appSettings;

  CustomDrawerController({
    required this.analyticsService,
    required this.userDataService,
    required this.appSettings,
  });

  String get versionLabel {
    String buildName = this.appSettings.versionName;
    int buildNumber = this.appSettings.versionNumber;
    return Utils.getversionLabel(buildName, buildNumber.toString());
  }

  Future rate() async {
    analyticsService.logOnTap("DRAWER", payload: "TAB=RATE");
    await LaunchReview.launch();
  }

  Future<void> toggleNightMode(bool mode) async {
    ThemeDataWrapper wrapper = ThemeDataWrapper.light();
    if (mode == true) {
      wrapper = ThemeDataWrapper.dark();
    }
    AppSessionManager.instance.updateTheme(wrapper);
    await userDataService.setNightMode(mode);
  }

  bool isNightMode() {
    AppSession? session = AppSessionManager.instance.currentSession;
    if (session != null) {
      return session.themeDataWrapper.appTheme == AppTheme.DARK;
    } else {
      return false;
    }
  }
}
