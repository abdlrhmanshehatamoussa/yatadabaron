import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/services/_i_local_repository.dart';
import 'package:yatadabaron/services/_i_remote_repository.dart';

class ReleaseInfoService implements IReleaseInfoService {
  ReleaseInfoService(
      {required this.localRepository,
      required this.remoteRepository,
      required this.networkDetector});

  final ILocalRepository<ReleaseInfo> localRepository;
  final IRemoteRepository<ReleaseInfo> remoteRepository;
  final INetworkDetectorService networkDetector;

  @override
  Future<int> syncReleases() async {
    try {
      List<ReleaseInfo> remotes = await _getRemote();
      if (remotes.isNotEmpty) await localRepository.replace(remotes);
      return remotes.length;
    } catch (e) {
      print("Error while synchronizing releases");
    }
    return 0;
  }

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    try {
      List<ReleaseInfo> local = await localRepository.getAll();
      local.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      return local;
    } catch (e) {
      print(
          "Error while fetching releases from local repository: ${e.toString()}");
    }
    return [];
  }

  Future<List<ReleaseInfo>> _getRemote() async {
    try {
      bool isOnline = await networkDetector.isOnline();
      if (isOnline == false) {
        return [];
      }
      List<ReleaseInfo> results = await remoteRepository.fetchAll();
      results.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      return results;
    } catch (e) {
      print(
          "Error while fetching releases from remote repository: ${e.toString()}");
      return [];
    }
  }
}
