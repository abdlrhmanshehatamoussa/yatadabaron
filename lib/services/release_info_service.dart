import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/services/_i_local_repository.dart';
import 'package:simply/simply.dart';

class ReleaseInfoService implements IReleaseInfoService, ISimpleService {
  ReleaseInfoService({
    required this.localRepository,
    required this.networkDetector,
  });

  final ILocalRepository<ReleaseInfo> localRepository;
  final INetworkDetectorService networkDetector;

  Future<List<ReleaseInfo>> _getRemote() async {
    bool isOnline = await networkDetector.isOnline();
    if (isOnline == false) {
      return [];
    }
    try {
      var releasesSnaphost =
          await FirebaseFirestore.instance.collection("releases").get();
      var releases = releasesSnaphost.docs.map((e) => e.data());
      List<ReleaseInfo> results = releases
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
