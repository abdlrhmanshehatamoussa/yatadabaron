import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/app/page_manager.dart';
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


class App{
  static Future<AppSettings> start() async {
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
      AppSettings appSettings = configurationManager.getAppSettings();

      //Intializate service manager
      ServiceManager serviceManager = ServiceManager(
        preferences: pref,
        settings: appSettings,
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

      return appSettings;
    } catch (e) {
      throw Exception("Initialization error: $e");
    }
  }
}

class AppView extends StatelessWidget {
  Widget _loading(String versionLabel) {
    return CustomMaterialApp(
      widget: Splash(
        child:LoadingWidget(),
        versionLabel: versionLabel,
      ),
      theme: ThemeData.light(),
    );
  }

  Widget _error(String versionLabel) {
    return CustomMaterialApp(
      widget: Splash(
        versionLabel: versionLabel,
        child:Text(
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

  Widget _body(AppSession appSession) {
    return CustomMaterialApp(
      widget: PageManager.instance.home(),
      theme: appSession.themeDataWrapper.themeData,
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Load version label properly
    String versionLabel = "";
    return FutureBuilder<AppSettings>(
      future: App.start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<AppSettings> snapshot,
      ) {
        if (!snapshot.hasData) {
          return _loading(versionLabel);
        }
        AppSettings? appSettings = snapshot.data;
        if (appSettings != null) {
          return StreamBuilder<AppSession>(
            stream: AppSessionManager.instance.stream,
            builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
              if (!sessionSnapshot.hasData) {
                return _loading(versionLabel);
              }
              return _body(sessionSnapshot.data!);
            },
          );
        } else {
          return _error(versionLabel);
        }
      },
    );
  }
}
