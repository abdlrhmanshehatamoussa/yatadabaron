import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class IReleaseInfoService extends SimpleService<IReleaseInfoService> {
  Future<List<ReleaseInfo>> getReleases();
  Future<int> syncReleases();
}
