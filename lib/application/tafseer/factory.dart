import 'package:yatadabaron/modules/persistence.module.dart';
import 'package:yatadabaron/persistence/repositories/tafseer_source_repository.dart';
import 'interface.dart';
import 'tafseer-service.dart';

class TafseerServiceFactory {
  static Future<ITafseerService> create() async {
    await DatabaseProvider.initialize();
    return TafseerService(
      VerseTafseerRepository.instance,
      TafseerSourceRepository.instance,
    );
  }
}
