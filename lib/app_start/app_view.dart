import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/pages/splash/view.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/custom_material_app.dart';
import 'app.dart';
import 'controller_manager.dart';
import 'session_manager.dart';

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ControllerManager>(
      future: App.start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ControllerManager> managerSnapshot,
      ) {
        if (managerSnapshot.hasData && managerSnapshot.data != null) {
          return StreamBuilder<AppSession>(
            stream: AppSessionManager.instance.stream,
            builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
              return CustomMaterialApp(
                widget: Provider(
                  child: HomePage(),
                  create: (context) => managerSnapshot.data,
                ),
                theme: sessionSnapshot.data!.themeDataWrapper.themeData,
              );
            },
          );
        } else {
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
      },
    );
  }
}
