import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';

class HomeController extends BaseController {
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;

  HomeController({
    required this.analyticsService,
    required this.userDataService,
  });

  Future<int?> getSavedChapterId() async {
    return await userDataService.getBookmarkChapter();
  }

  Future<int?> getSavedVerseId() async {
    return await userDataService.getBookmarkVerse();
  }
}
