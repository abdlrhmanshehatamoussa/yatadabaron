import 'package:yatadabaron/_modules/service_contracts.module.dart';

class VersionInfoService implements IVersionInfoService {
  final String buildId;
  final String versionName;

  VersionInfoService({
    required this.buildId,
    required this.versionName,
  });

  @override
  String getBuildId() {
    return this.buildId.length > 8
        ? this.buildId.substring(0, 7)
        : this.buildId;
  }

  @override
  String getVersionName() {
    return this.versionName;
  }
}
