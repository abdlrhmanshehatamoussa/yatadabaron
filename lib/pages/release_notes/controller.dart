import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';

class ReleaseNotesController {
  ReleaseNotesController();

  late IReleaseInfoService releaseInfoService =
      Simply.get<IReleaseInfoService>();
  late IVersionInfoService versionInfoService =
      Simply.get<IVersionInfoService>();

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
