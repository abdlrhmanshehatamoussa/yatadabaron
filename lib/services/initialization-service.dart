import 'package:Yatadabaron/modules/persistence.module.dart';
import './analytics-service.dart';
import './configurations-service.dart';
import './database-provider.dart';

class InitializationService {
  static InitializationService instance = InitializationService._();
  InitializationService._();

  Future<bool> initialize() async {
    bool db = await DatabaseProvider.initialize();
    bool shp = await UserDataRepository.instance.initialize();
    bool conf = await ConfigurationService.instance.initialize();
    bool anl = await AnalyticsService.initialize();
    return (db && shp && conf && anl);
  }
}
