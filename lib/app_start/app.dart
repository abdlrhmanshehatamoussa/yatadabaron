import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/app_start/page_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
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
  Future<bool> _start() async {
    try {
      //Load platform specific providers
      SharedPreferences pref = await SharedPreferences.getInstance();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      //Initialize configurations
      await dotenv.load(fileName: 'assets/.env');
      ConfigurationManager configurationManager = ConfigurationManager(
        versionName: packageInfo.version,
        buildNumber: int.tryParse(packageInfo.buildNumber) ?? 0,
        configurationValues: dotenv.env,
      );
      AppSettings settings = await configurationManager.getAppSettings();

      //Intializate service manager
      ServiceManager serviceManager = ServiceManager(
        preferences: pref,
        settings: settings,
      );

      //Initialize database provider
      //TODO: Change database intialization technique
      await DatabaseProvider.initialize();

      //Initialize the navigation manager
      PageManager.instance = PageManager(serviceManager: serviceManager);

      IAnalyticsService analyticsService =
          serviceManager.getService<IAnalyticsService>();
      IUserDataService userDataService =
          serviceManager.getService<IUserDataService>();

      //Log events
      await analyticsService.logAppStarted();
      await analyticsService.syncAllLogs();

      //Initialize the session
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

      return true;
    } catch (e) {
      throw Exception("Initialization error: $e");
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

  Widget _body(BuildContext context) {
    return StreamBuilder<AppSession>(
      stream: AppSessionManager.instance.stream,
      builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
        return CustomMaterialApp(
          widget: PageManager.instance.home(),
          theme: sessionSnapshot.data!.themeDataWrapper.themeData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        if (!snapshot.hasData) {
          return _loading();
        }
        bool? done = snapshot.data;
        if (done == true) {
          return _body(context);
        } else {
          return _error();
        }
      },
    );
  }
}
