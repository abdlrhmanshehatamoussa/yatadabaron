import 'package:yatadabaron/viewmodels/module.dart';

abstract class IUserDataService {
  Future<void> addMushafLocation(int chapterId, int verseId);

  Future<List<MushafLocation>> getMushafLocations();

  Future<MushafLocation?> getLastMushafLocation();

  Future<bool?> getNightMode();

  Future<void> setNightMode(bool nightMode);
}
