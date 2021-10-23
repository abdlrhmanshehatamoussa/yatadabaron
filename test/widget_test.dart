import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/app_start/service_manager.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';

void main() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ServiceManager serviceManager = ServiceManager(
    preferences: pref,
    settings: AppSettings(
      cloudHubApiUrl: "",
      cloudHubAppGuid: "",
      cloudHubClientKey: "",
      cloudHubClientSecret: "",
      tafseerSourcesURL: "",
      tafseerTextURL: "",
      versionName: "",
      versionNumber: 0,
    ),
  );
  IUserDataService service = serviceManager.getService<IUserDataService>();
  int? x = await service.getBookmarkChapter();
  print(x??0);
}
