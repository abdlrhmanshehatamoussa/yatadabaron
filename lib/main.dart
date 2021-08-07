import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/services/initialization-service.dart';
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
  //returns a metrial app wrapper for the given widget using the given theme
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
      future: InitializationService.instance.initialize(),
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
}
