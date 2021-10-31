import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/module.dart';

class ReleaseNotesController {
  final IReleaseInfoService releaseInfoService;

  ReleaseNotesController({
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
