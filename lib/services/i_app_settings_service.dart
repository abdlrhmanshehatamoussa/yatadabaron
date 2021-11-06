import 'package:yatadabaron/viewmodels/module.dart';

abstract class IAppSettingsService {
  AppSettings get currentValue;
  Future<void> updateNightMode(bool nightMode);
}
