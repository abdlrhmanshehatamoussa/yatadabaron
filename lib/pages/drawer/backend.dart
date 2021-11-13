import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class DrawerBackend extends SimpleBackend {
  DrawerBackend(BuildContext context) : super(context);

  late IAnalyticsService analyticsService = getService<IAnalyticsService>();
  late IAppSettingsService appSettingsService =
      getService<IAppSettingsService>();
  late IVersionInfoService versionInfoService =
      getService<IVersionInfoService>();
  late IUserService userService = getService<IUserService>();

  User? get currentUser => userService.currentUser;

  Future rate() async {
    analyticsService.logOnTap("DRAWER", payload: "TAB=RATE");
    await LaunchReview.launch();
  }

  Future<void> toggleNightMode(bool mode) async {
    await appSettingsService.updateNightMode(mode);
    reloadApp();
  }

  bool isNightMode() {
    return appSettingsService.currentValue.nightMode;
  }

  String get versionLabel {
    String currentVersion = versionInfoService.getVersionName();
    return [Localization.RELEASE_NAME, currentVersion].join(" : ");
  }
}
