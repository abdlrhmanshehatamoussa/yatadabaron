import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/services.module.dart';

class TafseerSourcesService implements ITafseerSourcesService, ISimpleService {
  TafseerSourcesService({
    required this.localRepo,
    required this.networkDetectorService,
  });
  final ILocalRepository<TafseerSource> localRepo;
  final INetworkDetectorService networkDetectorService;

  Future<List<TafseerSource>> _getRemote() async {
    try {
      var isOnline = await this.networkDetectorService.isOnline();
      if (isOnline == false) return [];
      final Response response =
          await CloudHubPublicData.instance.getPublicData("tafseer_sources").defaultNetworkTimeout();
      List<dynamic> tafseerSourcesJson = jsonDecode(response.body);
      List<TafseerSource> results = tafseerSourcesJson
          .map((dynamic json) => TafseerSource.fromJsonRemote(json))
          .toList();
      return results;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TafseerSource>> getTafseerSources() async {
    try {
      List<TafseerSource> local = await localRepo.getAll();
      if (local.isEmpty) {
        List<TafseerSource> remote = await _getRemote();
        await localRepo.merge(remote, (a, b) => a.tafseerId == a.tafseerId);
        local = await localRepo.getAll();
      }
      return local;
    } catch (e) {
      return [];
    }
  }
}
