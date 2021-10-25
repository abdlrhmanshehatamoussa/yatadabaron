import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/models/app_settings.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/pages/home/controller.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/pages/search/controller.dart';
import 'package:yatadabaron/pages/search/view.dart';
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
import 'service_provider.dart';

class PageRouter {
  PageRouter({
    required this.serviceProvider,
    required this.appSettings,
  });

  final IServiceProvider serviceProvider;
  final AppSettings appSettings;
  static PageRouter? _instance;

  static set instance(PageRouter m) {
    if (_instance == null) {
      _instance = m;
    }
  }

  static PageRouter get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw Exception("Page manager has not been initialized!");
    }
  }

  Widget home() {
    return HomePage(
      HomeController(
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        userDataService: serviceProvider.getService<IUserDataService>(),
      ),
    );
  }

  Widget drawer() {
    return CustomDrawer(
      CustomDrawerController(
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        userDataService: serviceProvider.getService<IUserDataService>(),
        appSettings: this.appSettings,
      ),
    );
  }

  Widget search() {
    return SearchPage(
      SearchController(
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        chaptersService: serviceProvider.getService<IChaptersService>(),
        versesService: serviceProvider.getService<IVersesService>(),
      ),
    );
  }

  Widget mushaf({
    required int? chapterId,
    required int? verseId,
  }) {
    return MushafPage(
      MushafController(
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        chaptersService: serviceProvider.getService<IChaptersService>(),
        versesService: serviceProvider.getService<IVersesService>(),
        userDataService: serviceProvider.getService<IUserDataService>(),
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
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        chapterId: chapterId,
        userDataService: serviceProvider.getService<IUserDataService>(),
        versesService: serviceProvider.getService<IVersesService>(),
        verseId: verseId,
        onBookmarkSaved: onBookmarkSaved,
        tafseerService: serviceProvider.getService<ITafseerService>(),
        tafseerSourcesService:
            serviceProvider.getService<ITafseerSourcesService>(),
      ),
    );
  }

  Widget statistics() {
    return StatisticsPage(
      StatisticsController(
        analyticsService: serviceProvider.getService<IAnalyticsService>(),
        chaptersService: serviceProvider.getService<IChaptersService>(),
        versesService: serviceProvider.getService<IVersesService>(),
      ),
    );
  }

  Widget releaseNotes() {
    return ReleaseNotesPage(
      ReleaseNotesController(
        releaseInfoService: serviceProvider.getService<IReleaseInfoService>(),
      ),
    );
  }

  Widget about() {
    return AboutPage(BaseController());
  }
}