import 'package:yatadabaron/simple/module.dart';

abstract class IVersionInfoService extends SimpleService<IVersionInfoService> {
  String getVersionName();
  int? getBuildNumber();
}
