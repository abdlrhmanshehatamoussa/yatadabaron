import 'package:yatadabaron/services/interfaces/module.dart';

class VersionInfoService extends IVersionInfoService {
  final int? buildNumber;
  final String versionName;

  VersionInfoService({
    required this.buildNumber,
    required this.versionName,
  });

  @override
  int? getBuildNumber() {
    return this.buildNumber;
  }

  @override
  String getVersionName() {
    return this.versionName;
  }
}
