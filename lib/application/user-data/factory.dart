import 'package:yatadabaron/modules/persistence.module.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interface.dart';
import 'user-data-service.dart';

class UserDataServiceFactory {
  static Future<IUserDataService> create() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserDataRepository repo = UserDataRepository(pref);
    return new UserDataService(repo);
  }
}
