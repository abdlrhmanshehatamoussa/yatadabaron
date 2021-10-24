import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/service_manager.dart';
import 'package:yatadabaron/app/mvc/base_controller.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/pages/home/controller.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/release_notes/controller.dart';
import 'package:yatadabaron/pages/release_notes/view.dart';
import 'package:yatadabaron/pages/statistics/controller.dart';
import 'package:yatadabaron/pages/statistics/view.dart';
import 'package:yatadabaron/pages/tafseer/controller.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_sources_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';

class PageManager {
  PageManager({
    required this.serviceManager,
  });

  final ServiceManager serviceManager;
  static PageManager? _instance;

  static set instance(PageManager m) {
    if (_instance == null) {
      _instance = m;
    }
  }

  static PageManager get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw Exception("Page manager has not been initialized!");
    }
  }

  Widget drawer() {
    return CustomDrawer(
      CustomDrawerController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        userDataService: serviceManager.getService<IUserDataService>(),
      ),
    );
  }

  Widget home() {
    return HomePage(
      HomeController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        chaptersService: serviceManager.getService<IChaptersService>(),
        versesService: serviceManager.getService<IVersesService>(),
      ),
    );
  }

  Widget mushaf({
    required int? chapterId,
    required int? verseId,
  }) {
    return MushafPage(
      MushafController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        chaptersService: serviceManager.getService<IChaptersService>(),
        versesService: serviceManager.getService<IVersesService>(),
        userDataService: serviceManager.getService<IUserDataService>(),
        chapterId: chapterId,
        verseId: verseId,
      ),
    );
  }

  Widget tafseer({
    required int verseId,
    required int chapterId,
    required Function onBookmarkSaved,
  }) {
    return TafseerPage(
      TafseerPageController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        chapterId: chapterId,
        userDataService: serviceManager.getService<IUserDataService>(),
        versesService: serviceManager.getService<IVersesService>(),
        verseId: verseId,
        onBookmarkSaved: onBookmarkSaved,
        tafseerService: serviceManager.getService<ITafseerService>(),
        tafseerSourcesService:
            serviceManager.getService<ITafseerSourcesService>(),
      ),
    );
  }

  Widget statistics() {
    return StatisticsPage(
      StatisticsController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        chaptersService: serviceManager.getService<IChaptersService>(),
        versesService: serviceManager.getService<IVersesService>(),
      ),
    );
  }

  Widget releaseNotes() {
    return ReleaseNotesPage(
      ReleaseNotesController(
        releaseInfoService: serviceManager.getService<IReleaseInfoService>(),
      ),
    );
  }

  Widget about() {
    return AboutPage(BaseController());
  }
}
