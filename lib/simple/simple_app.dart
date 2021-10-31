import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/simple/module.dart';

enum _Status {
  DONE,
  UNKNOWN_ERROR,
}

class _Payload {
  final SimpleServiceProvider? serviceProvider;
  final _Status status;

  _Payload({
    this.serviceProvider,
    required this.status,
  });
}

abstract class SimpleApp extends StatelessWidget {
  Future<List<ISimpleService>> registerServices();
  Future<void> onStart(
    SimpleServiceProvider serviceProvider,
  );
  Widget app();
  Widget splashWidget();
  Widget startupErrorWidget(String errorMessage);

  Future<_Payload> start() async {
    try {
      List<ISimpleService> services = await registerServices();
      SimpleServiceProvider serviceProvider = SimpleServiceProvider(services);
      await onStart(serviceProvider);
      return _Payload(
        serviceProvider: serviceProvider,
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
                Provider<SimpleServiceProvider>(
                  create: (_) => payload.serviceProvider!,
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
