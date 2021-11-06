import 'package:flutter/material.dart';
import 'services/module.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class TestApp extends SimpleApp {
  @override
  Widget startupErrorPage(String errorMessage) {
    return Splash(
      child: Text(errorMessage),
      versionLabel: "",
    );
  }

  @override
  Widget splashPage() {
    return Splash(
      child: LoadingWidget(),
      versionLabel: "",
    );
  }

  @override
  Future<void> registerServices(ISimpleServiceRegistery registery) async {
    registery.register<IReleaseInfoService>(
      service: TestReleaseInfoService(),
    );
    registery.register<IVersionInfoService>(
      service: TestVersionInfoService(),
    );
  }

  @override
  Future<void> onAppStart(ISimpleServiceProvider serviceProvider) async {}

  @override
  Widget buildApp(ISimpleServiceProvider provider, String payload) {
    return CustomMaterialApp(
      widget: HomePage(),
    );
  }
}
