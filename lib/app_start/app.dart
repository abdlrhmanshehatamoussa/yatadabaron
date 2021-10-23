import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/app_start/navigation_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/pages/splash/view.dart';
import 'package:yatadabaron/services/helpers/database-provider.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/custom_material_app.dart';
import 'package:yatadabaron/widgets/loading-widget.dart';
import 'configuration_manager.dart';
import 'service_manager.dart';
import 'session_manager.dart';

class App extends StatelessWidget {
  Future<ControllerManager> _start() async {
    try {
      //TODO: Change database intialization technique
      await DatabaseProvider.initialize();
      await dotenv.load(fileName: 'assets/.env');
      SharedPreferences pref = await SharedPreferences.getInstance();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      ConfigurationManager configurationManager = ConfigurationManager(
        versionName: packageInfo.version,
        buildNumber: int.tryParse(packageInfo.buildNumber) ?? 0,
        configurationValues: dotenv.env,
      );

      AppSettings settings = await configurationManager.getAppSettings();
      ServiceManager serviceManager = ServiceManager(
        preferences: pref,
        settings: settings,
      );
      NavigationManager.initialize(serviceManager);

      IAnalyticsService analyticsService =
          serviceManager.getService<IAnalyticsService>();
      IUserDataService userDataService =
          serviceManager.getService<IUserDataService>();

      await analyticsService.logAppStarted();
      await analyticsService.syncAllLogs();

      bool? isNightMode = await userDataService.getNightMode();
      switch (isNightMode) {
        case null:
        case true:
          AppSessionManager.instance.updateTheme(ThemeDataWrapper.dark());
          break;
        case false:
          AppSessionManager.instance.updateTheme(ThemeDataWrapper.light());
          break;
        default:
      }

      return ControllerManager(
        serviceManager: serviceManager,
      );
    } catch (e) {
      throw UnimplementedError();
    }
  }

  Widget _loading() {
    return CustomMaterialApp(
      widget: Splash(
        LoadingWidget(),
      ),
      theme: ThemeData.light(),
    );
  }

  Widget _error() {
    return CustomMaterialApp(
      widget: Splash(
        Text(
          Localization.LOADING_ERROR,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      theme: ThemeData.light(),
    );
  }

  Widget _body(ControllerManager manager) {
    return StreamBuilder<AppSession>(
      stream: AppSessionManager.instance.stream,
      builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
        return CustomMaterialApp(
          widget: Provider(
            child: HomePage(manager.homeController()),
            create: (context) => manager,
          ),
          theme: sessionSnapshot.data!.themeDataWrapper.themeData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ControllerManager>(
      future: _start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ControllerManager> managerSnapshot,
      ) {
        if (!managerSnapshot.hasData) {
          return _loading();
        }
        ControllerManager? manager = managerSnapshot.data;
        if (manager != null) {
          return _body(manager);
        } else {
          return _error();
        }
      },
    );
  }
}
