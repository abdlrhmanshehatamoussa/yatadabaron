import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

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
