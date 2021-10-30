import 'dart:convert';

import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/helpers/api_helper.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'interfaces/i_release_info_service.dart';

class ReleaseInfoService extends IReleaseInfoService {
  final SharedPreferences preferences;
  final AppSettings appSettings;
  final PackageInfo packageInfo;
  final CloudHubAPIHelper apiHelper;

  ReleaseInfoService({
    required this.preferences,
    required this.packageInfo,
    required this.appSettings,
    required this.apiHelper,
  });

  Future<List<ReleaseInfo>> _getRemote() async {
    Response response = await this
        .apiHelper
        .httpGET(endpoint: CloudHubAPIHelper.ENDPOINT_RELEASES);
    String body = response.body;
    List<dynamic> releasesJson = jsonDecode(body);
    List<ReleaseInfo> results =
        releasesJson.map((dynamic json) => ReleaseInfo.fromJson(json)).toList();
    results.sort((a, b) => b.uniqueId.compareTo(a.uniqueId));
    return results;
  }

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    return _getRemote();
  }

  @override
  String getCurrentVersion() {
    return this.packageInfo.version;
  }
}
