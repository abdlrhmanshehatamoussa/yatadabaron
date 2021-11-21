import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class TestVersionInfoService implements IVersionInfoService, ISimpleService {
  @override
  String getBuildId() {
    return "43";
  }

  @override
  String getVersionName() {
    return "6.8.1";
  }
}
