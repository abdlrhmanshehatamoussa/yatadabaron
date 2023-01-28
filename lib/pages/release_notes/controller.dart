import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/main.dart';

class ReleaseNotesController {
  ReleaseNotesController(){
    refresh();
  }

  late IReleaseInfoService releaseInfoService =
      Simply.get<IReleaseInfoService>();
  late IVersionInfoService versionInfoService =
      Simply.get<IVersionInfoService>();
  final StreamObject<List<ReleaseInfo>> _releasesStreamObject =
      StreamObject(initialValue: []);

  Stream<List<ReleaseInfo>> get releasesStream => _releasesStreamObject.stream;

  Future<void> refresh() async {
    var releases = await releaseInfoService.getReleases();
    _releasesStreamObject.add(releases);
  }

  Future<int> syncReleases() async {
    int result = await this.releaseInfoService.syncReleases();
    await refresh();
    return result;
  }

  String getVersionName() {
    return this.versionInfoService.getVersionName();
  }
}
