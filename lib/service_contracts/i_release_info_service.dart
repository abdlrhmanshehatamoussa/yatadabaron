import 'package:yatadabaron/_modules/models.module.dart';

abstract class IReleaseInfoService {
  Future<List<ReleaseInfo>> getReleases();
  Future<int> syncReleases();
}
