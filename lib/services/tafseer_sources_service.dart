import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import 'package:yatadabaron/services/_i_remote_repository.dart';

class TafseerSourcesService implements ITafseerSourcesService {
  TafseerSourcesService({
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
