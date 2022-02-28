import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/cloudhub/cloudhub.dart';
import 'package:yatadabaron/services/_i_local_repository.dart';
import 'package:simply/simply.dart';

class ReleaseInfoService implements IReleaseInfoService, ISimpleService {
  ReleaseInfoService({required this.localRepository});

  final ILocalRepository<ReleaseInfo> localRepository;

  Future<List<ReleaseInfo>> _getRemote() async {
    try {
      Response response =
          await CloudHubPublicData.instance.getPublicData("releases");
      String body = response.body;
      List<dynamic> releasesJson = jsonDecode(body);
      List<ReleaseInfo> results = releasesJson
          .map((dynamic json) => ReleaseInfo.fromJsonRemote(json))
          .toList();
      return results;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int> syncReleases() async {
    List<ReleaseInfo> remotes = await _getRemote();
    if (remotes.isNotEmpty) await localRepository.replace(remotes);
    return remotes.length;
  }

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    List<ReleaseInfo> local = await localRepository.getAll();
    local.sort((a, b) => b.releaseName.compareTo(a.releaseName));
    return local;
  }
}
