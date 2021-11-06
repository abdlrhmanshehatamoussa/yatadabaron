import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class ReleaseNotesBackend implements ISimpleBackend {
  final IReleaseInfoService releaseInfoService;
  final IVersionInfoService versionInfoService;

  ReleaseNotesBackend({
    required this.releaseInfoService,
    required this.versionInfoService,
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

  String getVersionName() {
    return this.versionInfoService.getVersionName();
  }
}
