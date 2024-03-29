import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/main.dart';
import '../about/page.dart';
import '../release_notes/view.dart';

class DrawerCustomController {
  DrawerCustomController();

  late IAppSettingsService appSettingsService =
      Simply.get<IAppSettingsService>();
  late IVersionInfoService versionInfoService =
      Simply.get<IVersionInfoService>();
  late IEventLogger eventLogger = Simply.get<IEventLogger>();

  Future rate() async {
    await eventLogger.logTapEvent(
      description: "drawer",
      payload: {"tab": "rate"},
    );
    await LaunchReview.launch();
  }

  Future<void> toggleNightMode(bool mode) async {
    await appSettingsService.updateNightMode(mode);
    appReload("");
  }

  bool isNightMode() {
    return appSettingsService.currentValue.nightMode;
  }

  String get versionLabel {
    String currentVersion = versionInfoService.getVersionName();
    return [Localization.RELEASE_NAME, currentVersion].join(" : ");
  }

  void goReleaseNotesPage() {
    appNavigator.pushWidget(
      view: ReleaseNotesPage(),
    );
  }

  void goAboutPage() {
    appNavigator.pushWidget(
      view: AboutPage(),
    );
  }
}
