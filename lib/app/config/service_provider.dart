import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/viewmodels/module.dart';
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

abstract class IServiceProvider {
  T getService<T>();
}

class ServiceProvider implements IServiceProvider {
  ServiceProvider({
    required this.appSettings,
    required this.packageInfo,
    required this.preferences,
  });

  final AppSettings appSettings;
  final SharedPreferences preferences;
  final PackageInfo packageInfo;

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

  CloudHubAPIHelper _buildCloudHubApiHelper() {
    CloudHubAPIClientInfo info = CloudHubAPIClientInfo(
      apiUrl: appSettings.cloudHubApiUrl,
      applicationGUID: appSettings.cloudHubAppGuid,
      clientKey: appSettings.cloudHubClientKey,
      clientSecret: appSettings.cloudHubClientSecret,
    );
    return CloudHubAPIHelper(info);
  }

  IAnalyticsService get _analyticsService {
    return AnalyticsService(
      preferences: preferences,
      appVersion: appSettings.versionNumber,
      apiHelper: _buildCloudHubApiHelper(),
    );
  }

  IUserDataService get _userDataService {
    return UserDataService(
      preferences: preferences,
    );
  }

  IChaptersService get _chaptersService {
    return ChaptersService(
      databasePath: appSettings.databaseFilePath,
    );
  }

  IVersesService get _versesService {
    return VersesService(
      databaseFilePath: appSettings.databaseFilePath,
    );
  }

  ITafseerService get _tafseerService {
    return TafseerService(
        analyticsService: _analyticsService,
        tafseerURL: appSettings.tafseerTextURL);
  }

  ITafseerSourcesService get _tafseerSourcesService {
    return TafseerSourcesService(
      analyticsService: _analyticsService,
      tafseerSourcesFileURL: appSettings.tafseerSourcesURL,
    );
  }

  IReleaseInfoService get _releaseInfoService {
    return ReleaseInfoService(
      preferences: preferences,
      appSettings: appSettings,
      packageInfo: packageInfo,
      apiHelper: _buildCloudHubApiHelper(),
    );
  }
}
