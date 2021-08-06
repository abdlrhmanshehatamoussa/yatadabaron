import 'package:Yatadabaron/services/analytics-service.dart';
import 'package:Yatadabaron/services/configurations-service.dart';
import 'package:Yatadabaron/repositories/userdata-repository.dart';
import 'package:Yatadabaron/services/database-provider.dart';

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
