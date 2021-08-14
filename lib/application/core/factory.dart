import 'package:Yatadabaron/modules/persistence.module.dart';

import 'interface.dart';
import 'mushaf-service.dart';

class MushafServiceFactory {
  static Future<IMushafService> create() async {
    await DatabaseProvider.initialize();
    return MushafService(
      ChaptersRepository.instance,
      VersesRepository.instance,
      TafseerRepository.instance,
    );
  }
}
