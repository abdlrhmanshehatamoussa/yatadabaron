import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/viewmodels/mushaf_location.dart';
import 'interfaces/i_user_data_service.dart';

class UserDataService implements IUserDataService {
  UserDataService({
    required this.preferences,
  });

  final SharedPreferences preferences;

  static const String _NIGHT_MODE_KEY = "yatadabaron_night_mode";

  @override
  Future<bool?> getNightMode() async {
    return this.preferences.getBool(_NIGHT_MODE_KEY);
  }

  @override
  Future<void> setNightMode(bool nightMode) async {
    await this.preferences.setBool(_NIGHT_MODE_KEY, nightMode);
  }

  static List<MushafLocation> locations = [];

  @override
  Future<void> addMushafLocation(int chapterId, int verseId) async {
    //TODO: implement addMushafLocation
    MushafLocation toAdd =
        MushafLocation(chapterId: chapterId, verseId: verseId);
    locations.add(toAdd);
  }

  @override
  Future<MushafLocation?> getLastMushafLocation() async {
    // TODO: implement getLastMushafLocation
    return locations.length > 0 ? locations.last : null;
  }

  @override
  Future<List<MushafLocation>> getMushafLocations() async {
    // TODO: implement getMushafLocations
    return locations;
  }

  int? _getInt(String k) {
    try {
      return this.preferences.getInt(k);
    } catch (e) {
      return null;
    }
  }
}
