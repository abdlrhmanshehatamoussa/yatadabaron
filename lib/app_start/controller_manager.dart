import 'package:yatadabaron/app_start/service_manager.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/home/controller.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/release_notes/controller.dart';
import 'package:yatadabaron/pages/statistics/controller.dart';
import 'package:yatadabaron/pages/tafseer/controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_sources_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';

class ControllerManager {
  ControllerManager({
    required this.serviceManager,
  });

  final ServiceManager serviceManager;

  HomeController homeController() {
    return HomeController(
      analyticsService: serviceManager.getService<IAnalyticsService>(),
      chaptersService: serviceManager.getService<IChaptersService>(),
      versesService: serviceManager.getService<IVersesService>(),
    );
  }

  MushafController mushafController({
    int? chapterId,
    int? verseId,
  }) {
    return MushafController(
      analyticsService: serviceManager.getService<IAnalyticsService>(),
      chaptersService: serviceManager.getService<IChaptersService>(),
      versesService: serviceManager.getService<IVersesService>(),
      userDataService: serviceManager.getService<IUserDataService>(),
      chapterId: chapterId,
      verseId: verseId,
    );
  }

  TafseerPageController tafseerPageController({
    required int chapterId,
    required int verseId,
    required Function onBookmarkSaved,
  }) {
    return TafseerPageController(
      analyticsService: serviceManager.getService<IAnalyticsService>(),
      chapterId: chapterId,
      userDataService: serviceManager.getService<IUserDataService>(),
      versesService: serviceManager.getService<IVersesService>(),
      verseId: verseId,
      onBookmarkSaved: onBookmarkSaved,
      tafseerService: serviceManager.getService<ITafseerService>(),
      tafseerSourcesService: serviceManager.getService<ITafseerSourcesService>(),
    );
  }

  StatisticsController statisticsController() {
    return StatisticsController(
      analyticsService: serviceManager.getService<IAnalyticsService>(),
      chaptersService: serviceManager.getService<IChaptersService>(),
      versesService: serviceManager.getService<IVersesService>(),
    );
  }

  CustomDrawerController drawerController() {
    return CustomDrawerController(
      analyticsService: serviceManager.getService<IAnalyticsService>(),
      userDataService: serviceManager.getService<IUserDataService>(),
    );
  }

  ReleaseNotesController releaseNotesController() {
    return ReleaseNotesController(
      releaseInfoService: serviceManager.getService<IReleaseInfoService>(),
    );
  }
}
