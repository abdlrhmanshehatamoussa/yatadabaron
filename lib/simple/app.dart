import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class SimpleApp extends StatelessWidget {
  Future<void> registerServices(ISimpleServiceRegistery registery);
  Future<void> initialize(ISimpleServiceProvider serviceProvider);
  Widget app();
  Widget splashPage();
  Widget startupErrorPage(String errorMessage);

  Future<ISimpleServiceProvider> start() async {
    _ServiceManager manager = _ServiceManager();
    try {
      await registerServices(manager);
    } catch (e) {
      throw Exception("Error while registering services: $e");
    }
    try {
      await initialize(manager);
    } catch (e) {
      throw Exception("Error while initializing application: $e");
    }
    return manager;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ISimpleServiceProvider>(
      future: start(),
      builder: (
        BuildContext context,
        AsyncSnapshot<ISimpleServiceProvider> snapshot,
      ) {
        if (snapshot.hasData) {
          return Provider<ISimpleServiceProvider>(
            child: app(),
            create: (_) => snapshot.data!,
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: startupErrorPage(snapshot.error.toString()),
          );
        } else {
          return MaterialApp(
            home: splashPage(),
          );
        }
      },
    );
  }
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
      throw Exception(
          "No services were registered for the type [$key], please register!");
    }
    return this._map[key] as T;
  }
}
