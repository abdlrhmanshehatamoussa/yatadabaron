import 'package:Yatadabaron/modules/persistence.module.dart';

import 'interface.dart';
import 'user-data-service.dart';

class UserDataServiceFactory {
  static Future<IUserDataService> create() async {
    await UserDataRepository.instance.initialize();
    return new UserDataService();
  }
}
