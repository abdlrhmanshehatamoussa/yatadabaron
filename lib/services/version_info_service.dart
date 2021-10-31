import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';

class VersionInfoService implements IVersionInfoService, ISimpleService {
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

  @override
  Type get getAs => IVersionInfoService;
}
