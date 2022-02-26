import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/simple/_module.dart';

class VersionInfoService implements IVersionInfoService, ISimpleService {
  final String buildId;
  final String versionName;

  VersionInfoService({
    required this.buildId,
    required this.versionName,
  });

  @override
  String getBuildId() {
    return this.buildId;
  }

  @override
  String getVersionName() {
    return this.versionName;
  }
}
