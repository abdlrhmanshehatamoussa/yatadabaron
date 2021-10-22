import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/home/controller.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/release_notes/controller.dart';
import 'package:yatadabaron/pages/statistics/controller.dart';
import 'package:yatadabaron/pages/tafseer/controller.dart';
import 'package:yatadabaron/services/analytics-service.dart';
import 'package:yatadabaron/services/chapters_service.dart';
import 'package:yatadabaron/services/helpers/api_helper.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_sources_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'package:yatadabaron/services/release_info_service.dart';
import 'package:yatadabaron/services/tafseer_service.dart';
import 'package:yatadabaron/services/tafseer_sources_service.dart';
import 'package:yatadabaron/services/user_data_service.dart';
import 'package:yatadabaron/services/verses_service.dart';

class ControllerManager {
  ControllerManager({
    required this.settings,
    required this.preferences,
  });

  final AppSettings settings;
  final SharedPreferences preferences;

  IAnalyticsService get _analyticsService {
    CloudHubAPIClientInfo info = CloudHubAPIClientInfo(
      apiUrl: settings.cloudHubApiUrl,
      applicationGUID: settings.cloudHubAppGuid,
      clientKey: settings.cloudHubClientKey,
      clientSecret: settings.cloudHubClientSecret,
    );
    CloudHubAPIHelper helper = CloudHubAPIHelper(info);
    return AnalyticsService(
      preferences: preferences,
      appVersion: settings.versionNumber,
      apiHelper: helper,
    );
  }

  IUserDataService get _userDataService {
    return UserDataService(
      preferences: preferences,
    );
  }

  IChaptersService get _chaptersService {
    return ChaptersService();
  }

  IVersesService get _versesService {
    return VersesService();
  }

  ITafseerService get _tafseerService {
    return TafseerService(
      analyticsService: _analyticsService,
      tafseerURL: settings.tafseerTextURL
    );
  }

  ITafseerSourcesService get _tafseerSourcesService {
    return TafseerSourcesService(
      analyticsService: _analyticsService,
      tafseerSourcesFileURL: settings.tafseerSourcesURL,
    );
  }

  IReleaseInfoService get _releaseInfoService {
    return ReleaseInfoService(
      preferences: preferences
    );
  }

  HomeController homeController() {
    return HomeController(
      analyticsService: _analyticsService,
      chaptersService: _chaptersService,
      versesService: _versesService,
    );
  }

  MushafController mushafController({
    int? chapterId,
    int? verseId,
  }) {
    return MushafController(
      analyticsService: _analyticsService,
      chaptersService: _chaptersService,
      versesService: _versesService,
      userDataService: _userDataService,
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
      analyticsService: _analyticsService,
      chapterId: chapterId,
      userDataService: _userDataService,
      versesService: _versesService,
      verseId: verseId,
      onBookmarkSaved: onBookmarkSaved,
      tafseerService: _tafseerService,
      tafseerSourcesService: _tafseerSourcesService
    );
  }

  StatisticsController statisticsController() {
    return StatisticsController(
      analyticsService: _analyticsService,
      chaptersService: _chaptersService,
      versesService: _versesService,
    );
  }

  CustomDrawerController drawerController() {
    return CustomDrawerController(
      analyticsService: _analyticsService,
      userDataService: _userDataService,
    );
  }

  ReleaseNotesController releaseNotesController(){
    return ReleaseNotesController(
      releaseInfoService: _releaseInfoService
    );
  }
}
