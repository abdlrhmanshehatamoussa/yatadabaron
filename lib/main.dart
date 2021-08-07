import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/persistence.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Yatadabaron/presentation/home/viewmodel.dart';
import 'presentation/home/view.dart';
import 'presentation/shared-widgets/custom-error-widget.dart';
import 'presentation/shared-widgets/loading-widget.dart';
import 'presentation/splash/splash.dart';

void main() {
  runApp(App());
}

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
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return materialApp(
              widget: Provider(
                create: (BuildContext context) => SearchSessionBloc(),
                child: HomePage(),
              ),
              theme: Theming.darkTheme(),
            );
          } else {
            return materialApp(
              widget: CustomErrorWidget(),
              theme: ThemeData.light(),
            );
          }
        } else {
          //Loading please wait
          return materialApp(
            widget: Splash(LoadingWidget()),
            theme: ThemeData.light(),
          );
        }
      },
    );
  }

  Future<bool> _initialize() async {
    bool db = await DatabaseProvider.initialize();
    bool shp = await UserDataRepository.instance.initialize();
    bool conf = await ConfigurationService.instance.initialize();
    bool anl = await AnalyticsService.initialize();
    return (db && shp && conf && anl);
  }
}
