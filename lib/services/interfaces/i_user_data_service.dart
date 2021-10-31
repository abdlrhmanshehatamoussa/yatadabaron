import 'package:yatadabaron/viewmodels/module.dart';

abstract class IUserDataService{
  Future<void> removeMushafLocation(MushafLocation location);

  Future<bool> addMushafLocation(MushafLocation location);

  Future<List<MushafLocation>> getMushafLocations();

  Future<MushafLocation?> getLastMushafLocation();

  Future<bool?> getNightMode();

  Future<void> setNightMode(bool nightMode);
}
