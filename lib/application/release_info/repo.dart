import 'package:yatadabaron/modules/domain.module.dart';

abstract class IReleaseInfoRepository {
  Future<List<ReleaseInfo>> getRemote();
  Future<List<ReleaseInfo>> getLocal();
  Future<void> setLocal();
}
