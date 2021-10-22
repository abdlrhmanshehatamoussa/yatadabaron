import 'package:yatadabaron/models/module.dart';

abstract class IConfigurationService {
  Future<AppSettings> getAppSettings();
}
