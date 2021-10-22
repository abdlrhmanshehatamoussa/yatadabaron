import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_release_info_service.dart';

class ReleaseNotesController {
  final IReleaseInfoService releaseInfoService;
  ReleaseNotesController({
    required this.releaseInfoService,
  });
  Future<List<ReleaseInfo>> getVersions() async {
    return await releaseInfoService.getReleases();
  }
}
