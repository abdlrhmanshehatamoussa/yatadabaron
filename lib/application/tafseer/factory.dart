import 'package:yatadabaron/modules/persistence.module.dart';
import 'package:yatadabaron/persistence/repositories/tafseer_source_repository.dart';
import 'interface.dart';
import 'tafseer-service.dart';

class TafseerServiceConfigurations {
  final String tafseerSourcesURL;
  final String tafseerTextURL;

  TafseerServiceConfigurations({
    required this.tafseerSourcesURL,
    required this.tafseerTextURL,
  });
}

class TafseerServiceFactory {
  static Future<ITafseerService> create(
    TafseerServiceConfigurations config
  ) async {
    await DatabaseProvider.initialize();
    return TafseerService(
      VerseTafseerRepository(
          remoteURL: config.tafseerTextURL
      ),
      TafseerSourceRepository(
        remoteFileURL: config.tafseerSourcesURL
      ),
    );
  }
}
