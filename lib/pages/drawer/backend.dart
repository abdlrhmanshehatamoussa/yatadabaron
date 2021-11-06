import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class DrawerBackend implements ISimpleBackend {
  final IAnalyticsService analyticsService;
  final IAppSettingsService appSettingsService;

  DrawerBackend({
    required this.analyticsService,
    required this.appSettingsService,
  });

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
}
