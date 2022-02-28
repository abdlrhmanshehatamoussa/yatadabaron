import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/cloudhub/cloudhub.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/services.module.dart';

class TafseerSourcesService implements ITafseerSourcesService, ISimpleService {
  TafseerSourcesService({required this.apiHelper, required this.localRepo});
  final CloudHubSDK apiHelper;
  final ILocalRepository<TafseerSource> localRepo;

  Future<List<TafseerSource>> _getRemote() async {
    try {
      final Response response = await this
          .apiHelper
          .httpGET(endpoint: CloudHubSDK.ENDPOINT_TAFSEER_SOURCES);
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
