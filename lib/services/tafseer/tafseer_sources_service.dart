import 'package:yatadabaron/models/_module.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/commons/api_helper.dart';
import 'package:yatadabaron/simple/_module.dart';
import 'package:yatadabaron/services/_module.dart';

import 'i_tafseer_sources_service.dart';
 
class TafseerSourcesService implements ITafseerSourcesService, ISimpleService {
  TafseerSourcesService({required this.apiHelper, required this.localRepo});
  final CloudHubAPIHelper apiHelper;
  final ILocalRepository<TafseerSource> localRepo;

  Future<List<TafseerSource>> _getRemote() async {
    try {
      final Response response = await this
          .apiHelper
          .httpGET(endpoint: CloudHubAPIHelper.ENDPOINT_TAFSEER_SOURCES);
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
        await localRepo.merge(remote);
        local = await localRepo.getAll();
      }
      return local;
    } catch (e) {
      return [];
    }
  }
}
