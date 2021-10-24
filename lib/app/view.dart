import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/splash/view.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/custom_material_app.dart';
import 'package:yatadabaron/widgets/loading-widget.dart';
import 'controller.dart';
import 'config/page_router.dart';
import 'config/session_manager.dart';

class AppView extends BaseView<AppController> {
  AppView(AppController controller) : super(controller);

  Widget _loading() {
    return CustomMaterialApp(
      widget: Splash(
        child: LoadingWidget(),
        versionLabel: "",
      ),
      theme: ThemeData.light(),
    );
  }

  Widget _error() {
    return FutureBuilder<String>(
      future: this.controller.getVersionLabel(),
      builder: (_, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return _loading();
        }
        String versionLabel = snapshot.data!;
        return CustomMaterialApp(
          widget: Splash(
            versionLabel: versionLabel,
            child: Text(
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
      },
    );
  }

  Widget _body() {
    return StreamBuilder<AppSession>(
      stream: AppSessionManager.instance.stream,
      builder: (_, AsyncSnapshot<AppSession> sessionSnapshot) {
        if (!sessionSnapshot.hasData) {
          return _loading();
        }
        return CustomMaterialApp(
          widget: PageRouter.instance.home(),
          theme: sessionSnapshot.data!.themeDataWrapper.themeData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: this.controller.start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> snapshot,
      ) {
        if (!snapshot.hasData) {
          return _loading();
        }
        bool? done = snapshot.data;
        if ((done ?? false) == true) {
          return _body();
        } else {
          return _error();
        }
      },
    );
  }
}
