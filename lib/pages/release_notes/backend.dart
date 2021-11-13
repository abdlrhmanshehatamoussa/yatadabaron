import 'package:flutter/cupertino.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class ReleaseNotesBackend extends SimpleBackend {
  ReleaseNotesBackend(BuildContext context) : super(context);

  late IReleaseInfoService releaseInfoService =
      getService<IReleaseInfoService>();
  late IVersionInfoService versionInfoService =
      getService<IVersionInfoService>();

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