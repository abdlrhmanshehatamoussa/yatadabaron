import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';

//Interface
abstract class IAppSettingsService {
  AppSettings get currentValue;
  Future<void> updateNightMode(bool nightMode);
}


//Imp
class AppSettingsService implements IAppSettingsService, ISimpleService {
  AppSettingsService({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  AppSettings get currentValue {
    return AppSettings(
      language: "ar",
      nightMode: _getBool(Constants.PREF_NIGHT_MODE_KEY) ?? false,
    );
  }

  @override
  Future<void> updateNightMode(bool nightMode) async {
    await this.sharedPreferences.setBool(
          Constants.PREF_NIGHT_MODE_KEY,
          nightMode,
        );
  }

  bool? _getBool(String k) {
    try {
      return this.sharedPreferences.getBool(k);
    } catch (e) {
      return null;
    }
  }
}
