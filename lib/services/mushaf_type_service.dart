import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class MushafTypeService implements IMushafTypeService {
  final SharedPreferences _prefs;
  static const String _mushafTypeKey = 'mushaf_type';

  MushafTypeService(this._prefs);

  @override
  MushafType getMushafType() {
    try {
      return MushafType.values[_prefs.getInt(_mushafTypeKey)!];
    } catch (e) {
      return MushafType.HAFS;
    }
  }

  @override
  Future<void> changeMushafType(MushafType mushafType) async {
    await _prefs.setInt(_mushafTypeKey, mushafType.index);
  }
}
