import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class MushafTypeService implements IMushafTypeService {
  final SharedPreferences _prefs;

  MushafTypeService(this._prefs);

  @override
  MushafType getMushafType() {
    var index = MushafType.HAFS.index;
    try {
      int? cachedIndex = _prefs.getInt('mushaf_type');
      if (cachedIndex != null) {
        index = cachedIndex;
      }
    } finally {}
    return MushafType.values[index];
  }

  @override
  Future<void> changeMushafType(MushafType mushafType) async {
    await _prefs.setInt('mushaf_type', mushafType.index);
  }
}
