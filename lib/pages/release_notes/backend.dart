import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/backend.dart';

class ReleaseNotesBackend implements ISimpleBackend {
  final IReleaseInfoService releaseInfoService;

  ReleaseNotesBackend({
    required this.releaseInfoService,
  });
  Future<List<ReleaseInfo>> getVersions() async {
    try {
      return await releaseInfoService.getReleases();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> syncReleases() async {
    int result = await this.releaseInfoService.syncReleases();
    return result;
  }
}
