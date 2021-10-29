import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';

class ReleaseNotesController extends BaseController {
  final IReleaseInfoService releaseInfoService;
  ReleaseNotesController({
    required this.releaseInfoService,
  });
  Future<List<ReleaseInfo>> getVersions() async {
    return await releaseInfoService.getReleases();
  }

  String getCurrentVersion() {
    return this.releaseInfoService.getCurrentVersion();
  }
}
