import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class IAppSettingsService extends SimpleService {
  AppSettings get currentValue;
  Future<void> updateNightMode(bool nightMode);
}
