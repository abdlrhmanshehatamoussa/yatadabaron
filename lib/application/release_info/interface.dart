import 'repo.dart';
import 'package:yatadabaron/modules/domain.module.dart';

abstract class IReleaseInfoService {
  final IReleaseInfoRepository repository;
  IReleaseInfoService(this.repository);
  Future<List<ReleaseInfo>> getReleases();
}
