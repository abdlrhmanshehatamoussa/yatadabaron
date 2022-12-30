import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class IReleaseInfoService extends SimpleService {
  Future<List<ReleaseInfo>> getReleases();
  Future<int> syncReleases();
}
