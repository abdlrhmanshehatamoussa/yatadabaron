import 'dart:convert';

import 'package:http/http.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import 'package:yatadabaron/services/_i_remote_repository.dart';

class TafseerSourcesServiceWeb implements ITafseerSourcesService {
  TafseerSourcesServiceWeb({
    required this.localRepo,
    required this.networkDetectorService,
    required this.remoteRepo,
  });
  final IRemoteRepository<TafseerSource> remoteRepo;
  final ILocalRepository<TafseerSource> localRepo;
  final INetworkDetectorService networkDetectorService;

  Future<List<TafseerSource>> _getRemote() async {
    var isOnline = await this.networkDetectorService.isOnline();
    if (isOnline == false) return [];
    List<TafseerSource> results = await remoteRepo.fetchAll();
    return results;
  }

  @override
  Future<List<TafseerSource>> getTafseerSources() async {
    try {
      List<TafseerSource> local = await localRepo.getAll();
      return local;
    } catch (e) {
      print(
          "Error while fetching tafseer sources from local repository: ${e.toString()}");
      return [];
    }
  }

  @override
  Future<bool> syncTafseerSources() async {
    try {
      List<TafseerSource> remote = await _getRemote();
      await localRepo.merge(remote, (a, b) => a.tafseerId == b.tafseerId);
      return true;
    } catch (e) {
      print(
          "Error while fetching tafseer sources from remote repository: ${e.toString()}");
      return false;
    }
  }
}

class TafseerSourceRemoteRepoWeb extends IRemoteRepository<TafseerSource> {
  @override
  Future<List<TafseerSource>> fetchAll() async {
    var response = await get(Uri.parse("http://api.quran-tafseer.com/tafseer"));
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    var result = <TafseerSource>[];
    for (var element in body) {
      result.add(
        TafseerSource(
          tafseerId: element["id"],
          tafseerName: element["book_name"],
          tafseerNameEnglish: element["book_name"],
        ),
      );
    }
    return result;
  }
}
