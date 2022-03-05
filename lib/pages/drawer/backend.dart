import 'package:cloudhub_sdk/cloudhub_sdk.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/_viewmodels/module.dart';
import 'package:yatadabaron/pages/account/view.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';

class DrawerBackend extends SimpleBackend {
  DrawerBackend(BuildContext context) : super(context);

  late IAppSettingsService appSettingsService =
      getService<IAppSettingsService>();
  late IVersionInfoService versionInfoService =
      getService<IVersionInfoService>();

  UserViewModel? get currentUser {
    CloudHubUser? user = CloudHubUsers.instance.currentUser;
    if (user == null) {
      return null;
    }
    return UserViewModel(
      globalId: user.globalId,
      displayName: user.displayName,
      email: user.email,
      imageUrl: user.imageURL,
    );
  }

  Future rate() async {
    await CloudHubAnalytics.instance.logOnTap(
      description: "drawer",
      payload: {"tab": "rate"},
    );
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

  void goAccountPage() {
    navigatePush(
      view: AccountView(),
    );
  }
}
