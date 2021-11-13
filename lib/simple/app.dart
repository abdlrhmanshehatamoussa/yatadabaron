import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers.dart';
import 'interfaces.dart';
import 'reloader.dart';
import 'service.dart';

abstract class SimpleApp extends StatelessWidget {
  SimpleApp({Key? key}) : super(key: key);
  
  final SimpleStreamObject<String> _streamObject = SimpleStreamObject<String>(
    initialValue: "",
  );

  Future<void> registerServices(ISimpleServiceRegistery registery);
  Future<void> onAppStart(ISimpleServiceProvider serviceProvider);
  Widget buildApp(ISimpleServiceProvider provider, String payload);
  Widget splashPage();
  Widget startupErrorPage(String errorMessage);

  Future<ISimpleServiceProvider> start() async {
    SimpleServiceManager manager = SimpleServiceManager();
    try {
      await registerServices(manager);
    } catch (e) {
      throw Exception("Error while registering services: $e");
    }
    try {
      await onAppStart(manager);
    } catch (e) {
      throw Exception("Error while initializing application: $e");
    }
    return manager;
  }

  @override
  Widget build(BuildContext context) {
    return _customFutureBuilder<ISimpleServiceProvider>(
      future: start(),
      build: (ISimpleServiceProvider provider) {
        ISimpleAppReloader appReloader = SimpleAppReloader(
          onReload: (String reloadMessage) => _streamObject.add(reloadMessage),
        );

        return MultiProvider(
          providers: [
            Provider<ISimpleServiceProvider>(
              create: (_) => provider,
            ),
            Provider<ISimpleAppReloader>(
              create: (_) => appReloader,
            ),
          ],
          child: _customStreamBuilder<String>(
            stream: _streamObject.stream,
            build: (String message) {
              return buildApp(provider, message);
            },
          ),
        );
      },
    );
  }

  Widget _customFutureBuilder<T>({
    required Future<T> future,
    required Widget Function(T) build,
  }) {
    return FutureBuilder<T>(
      future: future,
      builder: (_, AsyncSnapshot<T> snapshot) =>
          _customAsyncBuilder(snapshot, build),
    );
  }

  Widget _customStreamBuilder<T>({
    required Stream<T> stream,
    required Widget Function(T) build,
  }) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (_, AsyncSnapshot<T> snapshot) =>
          _customAsyncBuilder(snapshot, build),
    );
  }

  Widget _customAsyncBuilder<T>(
    AsyncSnapshot<T> snapshot,
    Widget Function(T) build,
  ) {
    if (snapshot.hasData) {
      return build(snapshot.data!);
    } else if (snapshot.hasError) {
      return MaterialApp(
        home: startupErrorPage(
          snapshot.error.toString(),
        ),
      );
    } else {
      return MaterialApp(
        home: splashPage(),
      );
    }
  }
}
