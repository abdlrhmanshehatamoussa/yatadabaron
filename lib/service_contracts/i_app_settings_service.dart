import 'package:yatadabaron/_modules/models.module.dart';

abstract class IAppSettingsService {
  AppSettings get currentValue;
  Future<void> updateNightMode(bool nightMode);
  Future<void> updateReciter(String v);
}
