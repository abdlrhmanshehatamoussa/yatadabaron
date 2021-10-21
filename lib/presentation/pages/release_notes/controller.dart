import 'package:yatadabaron/application/service-manager.dart';
import 'package:yatadabaron/modules/domain.module.dart';

class ReleaseNotesController {
  Future<List<ReleaseInfo>> getVersions() async {
    return await ServiceManager.instance.releaseInfoService.getReleases();
  }
}
