import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

abstract class IUserDataService extends SimpleService<IUserDataService> {
  Future<void> removeMushafLocation(MushafLocation location);

  Future<bool> addMushafLocation(MushafLocation location);

  Future<List<MushafLocation>> getMushafLocations();

  Future<MushafLocation?> getLastMushafLocation();

  Future<bool?> getNightMode();

  Future<void> setNightMode(bool nightMode);
}
