import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class SimpleView<CT extends ISimpleController>
    extends StatelessWidget {
  void _navigate({
    required BuildContext context,
    required Widget view,
    bool replace = true,
  }) {
    ISimpleServiceProvider serviceProvider =
        Provider.of<ISimpleServiceProvider>(
      context,
      listen: false,
    );
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
    required BuildContext context,
    required Widget view,
  }) {
    _navigate(
      context: context,
      view: view,
      replace: false,
    );
  }

  void navigateReplace({
    required BuildContext context,
    required Widget view,
  }) {
    _navigate(
      context: context,
      view: view,
      replace: true,
    );
  }

  T getService<T>(BuildContext context) {
    ISimpleServiceProvider serviceProvider =
        Provider.of<ISimpleServiceProvider>(context);
    return serviceProvider.getService<T>();
  }

  CT provideController(ISimpleServiceProvider serviceProvider);

  CT getController(BuildContext context) {
    ISimpleServiceProvider provider =
        Provider.of<ISimpleServiceProvider>(context);
    return provideController(provider);
  }
}
