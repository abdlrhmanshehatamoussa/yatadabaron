import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/presentation/modules/pages.module.dart';
import 'package:yatadabaron/presentation/modules/shared-controllers.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:yatadabaron/presentation/modules/shared.dtos.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  Widget materialApp({Widget? widget, ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      builder: (BuildContext context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      title: Localization.APP_TITLE,
      home: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initialize(),
      builder:
          (BuildContext context, AsyncSnapshot<bool> initializationSnapshot) {
        if (initializationSnapshot.hasData == false) {
          return materialApp(
            widget: Splash(LoadingWidget()),
            theme: ThemeData.light(),
          );
        }
        if ((initializationSnapshot.data ?? false) == false) {
          return materialApp(
            widget: CustomErrorWidget(),
            theme: ThemeData.light(),
          );
        } else {
          return StreamBuilder<ThemeDataWrapper>(
            stream: Provider.of<ThemeController>(context).stream,
            builder: (_, AsyncSnapshot<ThemeDataWrapper> themeSnapshot) {
              ThemeData? theme;
              if (themeSnapshot.hasData && themeSnapshot.data != null) {
                theme = themeSnapshot.data!.themeData;
              }
              return materialApp(
                widget: HomePage.wrappedWithProvider(),
                theme: theme,
              );
            },
          );
        }
      },
    );
  }

  Future<bool> _initialize() async {
    try{
      await ServiceManager.initialize();
      await ServiceManager.instance.analyticsService.logAppStarted();
      await ServiceManager.instance.analyticsService.syncAllLogs();
    return true;
    }catch(e){
      return false;
    }
  }
}
