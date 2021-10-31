import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/simple/module.dart';

enum _Status {
  DONE,
  UNKNOWN_ERROR,
}

class _Payload {
  final ISimpleServiceProvider? serviceProvider;
  final ISimpleControllerProvider? controllerProvider;
  final _Status status;

  _Payload({
    this.serviceProvider,
    this.controllerProvider,
    required this.status,
  });
}

abstract class SimpleApp extends StatelessWidget {
  Future<ISimpleServiceProvider> providerServices();
  Future<ISimpleControllerProvider> provideControllers(
    ISimpleServiceProvider serviceProvider,
  );
  Future<void> initialize(ISimpleServiceProvider serviceProvider);
  Widget app();
  Widget splashWidget();
  Widget startupErrorWidget(String errorMessage);

  Future<_Payload> start() async {
    try {
      ISimpleServiceProvider serviceProvider = await providerServices();
      ISimpleControllerProvider controllerProvider = await provideControllers(
        serviceProvider,
      );
      await initialize(serviceProvider);
      return _Payload(
        serviceProvider: serviceProvider,
        controllerProvider: controllerProvider,
        status: _Status.DONE,
      );
    } catch (e) {
      return _Payload(
        status: _Status.UNKNOWN_ERROR,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Payload>(
      future: start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<_Payload> snapshot,
      ) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: splashWidget(),
          );
        }
        _Payload payload = snapshot.data!;
        switch (payload.status) {
          case _Status.DONE:
            return MultiProvider(
              child: app(),
              providers: [
                Provider<ISimpleServiceProvider>(
                  create: (_) => payload.serviceProvider!,
                ),
                Provider<ISimpleControllerProvider>(
                  create: (_) => payload.controllerProvider!,
                ),
              ],
            );
          case _Status.UNKNOWN_ERROR:
          default:
            return MaterialApp(
              home: startupErrorWidget(
                  "Error while initializing the application"),
            );
        }
      },
    );
  }
}
