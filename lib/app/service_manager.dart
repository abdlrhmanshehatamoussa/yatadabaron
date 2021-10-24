import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
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

abstract class IServiceManager {
  T getService<T>();
}

class ServiceManager implements IServiceManager {
  ServiceManager({
    required this.settings,
    required this.preferences,
  });

  final AppSettings settings;
  final SharedPreferences preferences;

  @override
  T getService<T>() {
    Map<String, dynamic> values = Map();
    values[(IAnalyticsService).toString()] = _analyticsService;
    values[(IUserDataService).toString()] = _userDataService;
    values[(IReleaseInfoService).toString()] = _releaseInfoService;
    values[(IChaptersService).toString()] = _chaptersService;
    values[(IVersesService).toString()] = _versesService;
    values[(ITafseerService).toString()] = _tafseerService;
    values[(ITafseerSourcesService).toString()] = _tafseerSourcesService;
    return values[T.toString()] as T;
  }

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
        tafseerURL: settings.tafseerTextURL);
  }

  ITafseerSourcesService get _tafseerSourcesService {
    return TafseerSourcesService(
      analyticsService: _analyticsService,
      tafseerSourcesFileURL: settings.tafseerSourcesURL,
    );
  }

  IReleaseInfoService get _releaseInfoService {
    return ReleaseInfoService(preferences: preferences);
  }
}
