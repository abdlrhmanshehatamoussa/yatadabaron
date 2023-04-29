import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/_modules/models.module.dart';

class AppSettingsService implements IAppSettingsService {
  AppSettingsService({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  AppSettings get currentValue {
    return AppSettings(
      language: "ar",
      nightMode: _getBool(Constants.PREF_NIGHT_MODE_KEY) ?? false,
      reciterKey: _getString(Constants.PREF_RECITER_KEY),
    );
  }

  @override
  Future<void> updateNightMode(bool nightMode) async {
    await this.sharedPreferences.setBool(
          Constants.PREF_NIGHT_MODE_KEY,
          nightMode,
        );
  }

  String? _getString(String k) {
    try {
      return this.sharedPreferences.getString(k);
    } catch (e) {
      return null;
    }
  }

  bool? _getBool(String k) {
    try {
      return this.sharedPreferences.getBool(k);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateReciter(String reciterKey) async {
    await sharedPreferences.setString(Constants.PREF_RECITER_KEY, reciterKey);
  }
}
