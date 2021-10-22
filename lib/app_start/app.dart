import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class App {
  static Future<ControllerManager> start() async {
    try {
      //TODO: uncomment this
      //await ServiceManager.initialize();
      //await ServiceManager.instance.analyticsService.logAppStarted();
      //await ServiceManager.instance.analyticsService.syncAllLogs();

      // bool? isNightMode = await userDataService.getNightMode();
      // switch (isNightMode) {
      //   case null:
      //   case true:
      //     updateTheme(ThemeDataWrapper.dark());
      //     break;
      //   case false:
      //     updateTheme(ThemeDataWrapper.light());
      //     break;
      //   default:
      // }
      // AppSession session = AppSession(
      //   themeDataWrapper: ThemeDataWrapper.light(),
      // );
      throw UnimplementedError();
    } catch (e) {
      throw UnimplementedError();
    }
  }
}
