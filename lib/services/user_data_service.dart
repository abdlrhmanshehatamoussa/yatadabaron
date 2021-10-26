import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'interfaces/i_user_data_service.dart';

class UserDataService implements IUserDataService {
  UserDataService({
    required this.preferences,
  });

  final SharedPreferences preferences;

  static const String _NIGHT_MODE_KEY = "yatadabaron_night_mode";
  static const String _MUSHAF_LOCATIONS_KEY = "yatadabaron_mushaf_locations";

  @override
  Future<bool?> getNightMode() async {
    return _getBool(_NIGHT_MODE_KEY);
  }

  @override
  Future<void> setNightMode(bool nightMode) async {
    await this.preferences.setBool(_NIGHT_MODE_KEY, nightMode);
  }

  @override
  Future<bool> addMushafLocation(int chapterId, int verseId) async {
    //Fetch
    List<MushafLocation> locations = await getMushafLocations();

    //Check
    MushafLocation toAdd = MushafLocation(
      chapterId: chapterId,
      verseId: verseId,
    );
    bool exists =
        locations.any((MushafLocation loc) => loc.uniqueId == toAdd.uniqueId);
    if (!exists) {
      //Add
      locations.add(toAdd);

      //Encode
      List<String> encoded = [];
      for (var location in locations) {
        String json = jsonEncode(location.toJson());
        encoded.add(json);
      }

      //Save
      await this.preferences.setStringList(_MUSHAF_LOCATIONS_KEY, []);
      await this.preferences.setStringList(_MUSHAF_LOCATIONS_KEY, encoded);
      return true;
    }
    return false;
  }

  @override
  Future<MushafLocation?> getLastMushafLocation() async {
    List<MushafLocation> locations = await getMushafLocations();
    if (locations.length > 0) {
      return locations.last;
    }
  }

  @override
  Future<List<MushafLocation>> getMushafLocations() async {
    //Fetch
    List<String> mushafLocationsStr = _getList(_MUSHAF_LOCATIONS_KEY) ?? [];
    List<MushafLocation> results = [];
    //Decode
    for (var mushafLocationStr in mushafLocationsStr) {
      Map<String, dynamic> jsonObj = jsonDecode(mushafLocationStr);
      MushafLocation? loc = MushafLocation.fromJson(jsonObj);
      if (loc != null) {
        results.add(loc);
      }
    }
    return results;
  }

  bool? _getBool(String k) {
    try {
      return this.preferences.getBool(k);
    } catch (e) {
      return null;
    }
  }

  List<String>? _getList(String k) {
    try {
      return this.preferences.getStringList(k);
    } catch (e) {
      return null;
    }
  }
}
