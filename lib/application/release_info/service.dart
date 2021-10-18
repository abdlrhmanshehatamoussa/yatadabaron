import 'package:yatadabaron/application/release_info/repo.dart';
import 'package:yatadabaron/domain/models/release_info.dart';

import 'interface.dart';

class ReleaseInfoService extends IReleaseInfoService {
  ReleaseInfoService(IReleaseInfoRepository repository) : super(repository);

  @override
  Future<List<ReleaseInfo>> getReleases() async {
    return await repository.getLocal();
  }
}
