import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/modules/persistence.module.dart';
import 'repo.dart';
import 'interface.dart';
import 'service.dart';

class ReleaseInfoServiceFactory {
  static Future<IReleaseInfoService> create() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    IReleaseInfoRepository repo = ReleaseInfoRepository(preferences: pref);
    return ReleaseInfoService(repo);
  }
}
