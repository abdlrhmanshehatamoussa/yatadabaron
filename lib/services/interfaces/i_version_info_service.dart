import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class IVersionInfoService extends SimpleService<IVersesService> {
  String getVersionName();
  int? getBuildNumber();
}
