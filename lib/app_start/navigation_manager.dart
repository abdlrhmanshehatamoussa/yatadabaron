import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app_start/service_manager.dart';
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

class NavigationManager {
  NavigationManager({required this.context});

  final BuildContext context;
  static ServiceManager? _serviceManager;
  static ServiceManager get serviceManager {
    if (_serviceManager != null) {
      return _serviceManager!;
    } else {
      throw Exception("Service manager not initialized");
    }
  }

  static set serviceManager(v) {
    _serviceManager = v;
  }

  static NavigationManager? _instance;
  static NavigationManager of(BuildContext context) {
    if (_instance == null) {
      _instance = NavigationManager(context: context);
    }
    return _instance!;
  }

  void _navigate({
    required Widget view,
    bool replace = false,
  }) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (_) => view,
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  static void initialize(ServiceManager serviceManager) {
    NavigationManager.serviceManager = serviceManager;
  }

  Widget getDrawer() {
    return CustomDrawer(
      CustomDrawerController(
        analyticsService: serviceManager.getService<IAnalyticsService>(),
        userDataService: serviceManager.getService<IUserDataService>(),
      ),
    );
  }

  void goHome({
    required bool replace,
  }) {
    _navigate(
      replace: replace,
      view: HomePage(
        HomeController(
          analyticsService: serviceManager.getService<IAnalyticsService>(),
          chaptersService: serviceManager.getService<IChaptersService>(),
          versesService: serviceManager.getService<IVersesService>(),
        ),
      ),
    );
  }

  void goMushaf({
    required bool replace,
    required int chapterId,
    required int verseId,
  }) {
    _navigate(
      replace: replace,
      view: MushafPage(
        MushafController(
          analyticsService: serviceManager.getService<IAnalyticsService>(),
          chaptersService: serviceManager.getService<IChaptersService>(),
          versesService: serviceManager.getService<IVersesService>(),
          userDataService: serviceManager.getService<IUserDataService>(),
          chapterId: chapterId,
          verseId: verseId,
        ),
      ),
    );
  }

  void goTafseer({
    required int verseId,
    required int chapterId,
    required Function onBookmarkSaved,
    required bool replace,
  }) {
    _navigate(
      view: TafseerPage(
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
      ),
      replace: replace,
    );
  }

  void goStatistics({
    required bool replace,
  }) {
    _navigate(
      view: StatisticsPage(
        StatisticsController(
          analyticsService: serviceManager.getService<IAnalyticsService>(),
          chaptersService: serviceManager.getService<IChaptersService>(),
          versesService: serviceManager.getService<IVersesService>(),
        ),
      ),
    );
  }

  void goReleaseNotes({
    required bool replace,
  }) {
    _navigate(
      replace: replace,
      view: ReleaseNotesPage(
        ReleaseNotesController(
          releaseInfoService: serviceManager.getService<IReleaseInfoService>(),
        ),
      ),
    );
  }
}

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
      tafseerSourcesService:
          serviceManager.getService<ITafseerSourcesService>(),
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
