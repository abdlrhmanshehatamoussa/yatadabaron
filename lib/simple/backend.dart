import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'interfaces.dart';

abstract class SimpleBackend {
  SimpleBackend(this.context);

  final BuildContext context;

  void reloadApp({String? reloadMessage}) {
    ISimpleAppReloader appReloader = Provider.of<ISimpleAppReloader>(
      context,
      listen: false,
    );
    appReloader.reload(reloadMessage ?? "");
  }

  T getService<T>() {
    ISimpleServiceProvider serviceProvider =
        Provider.of<ISimpleServiceProvider>(
      context,
      listen: false
    );
    return serviceProvider.getService<T>();
  }

  void _navigate({
    required Widget view,
    bool replace = true,
  }) {
    ISimpleServiceProvider serviceProvider =
        Provider.of<ISimpleServiceProvider>(context, listen: false);
    MaterialPageRoute route = MaterialPageRoute(
      builder: (_) => MultiProvider(
        child: view,
        providers: [
          Provider<ISimpleServiceProvider>(
            create: (_) => serviceProvider,
          ),
        ],
      ),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  void navigatePush({
    required Widget view,
  }) {
    _navigate(
      view: view,
      replace: false,
    );
  }

  void navigateReplace({
    required Widget view,
  }) {
    _navigate(
      view: view,
      replace: true,
    );
  }
}
