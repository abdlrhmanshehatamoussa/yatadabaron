import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';
import 'package:yatadabaron/viewmodels/app_settings.dart';

class ReleaseNotesController extends BaseController {
  final IReleaseInfoService releaseInfoService;
  final AppSettings appSettings;

  ReleaseNotesController({
    required this.releaseInfoService,
    required this.appSettings,
  });
  Future<List<ReleaseInfo>> getVersions() async {
    try {
      return await releaseInfoService.getReleases();
    } catch (e) {
      print(e);
      return [];
    }
  }

  String getCurrentVersion() {
    return this.appSettings.versionName;
  }

  Future<int> syncReleases() async {
    int result = await this.releaseInfoService.syncReleases();
    return result;
  }
}
