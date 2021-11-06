import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class TestReleaseInfoService implements IReleaseInfoService, ISimpleService {
  @override
  Future<List<ReleaseInfo>> getReleases() async {
    return [];
  }

  @override
  Future<int> syncReleases() async {
    return 1;
  }
}
