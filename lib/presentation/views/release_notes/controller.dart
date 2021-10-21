import 'package:yatadabaron/application/release_info/interface.dart';
import 'package:yatadabaron/modules/domain.module.dart';

class ReleaseNotesController {
  final IReleaseInfoService releaseInfoService;
  ReleaseNotesController(this.releaseInfoService);
  Future<List<ReleaseInfo>> getVersions() async {
    return await releaseInfoService.getReleases();
  }
}
