import 'package:yatadabaron/models/module.dart';

abstract class IReleaseInfoService{
  Future<List<ReleaseInfo>> getReleases();
  Future<int> syncReleases();
}
