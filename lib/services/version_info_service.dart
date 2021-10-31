import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';

class VersionInfoService extends SimpleService<IVersionInfoService>
    implements IVersionInfoService {
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
