import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class DrawerBackend implements ISimpleBackend {
  final IAnalyticsService analyticsService;
  final IAppSettingsService appSettingsService;
  final IVersionInfoService versionInfoService;
  final IUserService userService;
  DrawerBackend({
    required this.analyticsService,
    required this.appSettingsService,
    required this.versionInfoService,
    required this.userService,
  });

  User? get currentUser => userService.currentUser;

  Future rate() async {
    analyticsService.logOnTap("DRAWER", payload: "TAB=RATE");
    await LaunchReview.launch();
  }

  Future<void> toggleNightMode(bool mode) async {
    await appSettingsService.updateNightMode(mode);
  }

  bool isNightMode() {
    return appSettingsService.currentValue.nightMode;
  }

  String get versionLabel {
    String currentVersion = versionInfoService.getVersionName();
    return [Localization.RELEASE_NAME, currentVersion].join(" : ");
  }
}
