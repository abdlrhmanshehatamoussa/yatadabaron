import 'package:launch_review/launch_review.dart';
import 'package:yatadabaron/app_start/session_manager.dart';
import 'package:yatadabaron/mvc/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class CustomDrawerController extends BaseController {
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;

  CustomDrawerController({
    required this.analyticsService,
    required this.userDataService,
  });

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

  Future<int?> getSavedChapterId() async {
    return await userDataService.getBookmarkChapter();
  }

  Future<int?> getSavedVerseId() async {
    return await userDataService.getBookmarkVerse();
  }
}
