import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/helpers/api_helper.dart';
import 'package:yatadabaron/simple/module.dart';
import 'interfaces/module.dart';

class ReleaseInfoService implements IReleaseInfoService, ISimpleService {
  ReleaseInfoService({
    required this.preferences,
    required this.apiHelper,
  });

  final SharedPreferences preferences;
  final CloudHubAPIHelper apiHelper;
  static const String _RELEASES_KEY = "YATADABARON_RELEASES";

  Future<List<ReleaseInfo>> _getRemote() async {
    try {
      Response response = await this.apiHelper.httpGET(
            endpoint: CloudHubAPIHelper.ENDPOINT_RELEASES,
          );
      String body = response.body;
      List<dynamic> releasesJson = jsonDecode(body);
      List<ReleaseInfo> results = releasesJson
          .map((dynamic json) => ReleaseInfo.fromJson(json))
          .toList();
      return results;
    } catch (e) {
      return [];
    }
  }

  Future<List<ReleaseInfo>> _getLocal() async {
    List<ReleaseInfo> results = [];
    List<String>? releaseAsStrX =
        this.preferences.getStringList(_RELEASES_KEY) ?? [];
    for (String releaseAsStr in releaseAsStrX) {
      Map<String, dynamic> releaseAsJson = jsonDecode(releaseAsStr);
      ReleaseInfo release = ReleaseInfo.fromJson(releaseAsJson);
      results.add(release);
    }
    return results;
  }

  Future<void> _addLocal(List<ReleaseInfo> toAdd) async {
    List<ReleaseInfo> locals = await _getLocal();
    locals.addAll(toAdd);
    List<String> localStr = locals.map((l) => l.toJson()).toList();
    await this.preferences.setStringList(_RELEASES_KEY, localStr);
  }

  @override
  Future<int> syncReleases() async {
    List<ReleaseInfo> remotes = await _getRemote();
    List<ReleaseInfo> locals = await _getLocal();
    List<ReleaseInfo> toAdd = [];
    for (var remote in remotes) {
      bool exists =
          locals.any((ReleaseInfo local) => local.uniqueId == remote.uniqueId);
      if (exists == false) {
        toAdd.add(remote);
      }
    }
    if (toAdd.length > 0) {
      _addLocal(toAdd);
    }
    return toAdd.length;
  }

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    List<ReleaseInfo> local = await _getLocal();
    local.sort((a, b) => b.uniqueId.compareTo(a.uniqueId));
    return local;
  }

  @override
  Type get getAs => IReleaseInfoService;
}
