import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/simple/module.dart';

enum _Status {
  DONE,
  UNKNOWN_ERROR,
}

class _Payload {
  final ISimpleServiceProvider? serviceProvider;
  final _Status status;

  _Payload({
    this.serviceProvider,
    required this.status,
  });
}

class _ServiceManager
    implements ISimpleServiceProvider, ISimpleServiceRegistery {
  final Map<String, ISimpleService> _map = Map();

  void register<T>({required ISimpleService service}) {
    String key = T.toString();
    bool exists = _map.containsKey(key);
    if (exists) {
      throw Exception(
          "Error while registering service for type [$key], type already registered");
    } else {
      _map[T.toString()] = service;
    }
  }

  @override
  T getService<T>() {
    String key = T.toString();
    bool exists = this._map.containsKey(key);
    if (exists == false) {
      throw Exception("No services were registered for the type [$key], please register!");
    }
    return this._map[key] as T;
  }
}

abstract class SimpleApp extends StatelessWidget {
  Future<void> registerServices(ISimpleServiceRegistery registery);
  Future<void> initialize(ISimpleServiceProvider serviceProvider);
  Widget app();
  Widget splashPage();
  Widget startupErrorPage(String errorMessage);

  Future<_Payload> start() async {
    try {
      _ServiceManager manager = _ServiceManager();
      await registerServices(manager);
      await initialize(manager);
      return _Payload(
        serviceProvider: manager,
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
            home: splashPage(),
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
              ],
            );
          case _Status.UNKNOWN_ERROR:
          default:
            return MaterialApp(
              home: startupErrorPage(
                  "Error while initializing the application"),
            );
        }
      },
    );
  }
}
