import 'package:yatadabaron/modules/domain.module.dart';

abstract class IConfigurationService {
  Future<AppSettings> getAppSettings();
}
