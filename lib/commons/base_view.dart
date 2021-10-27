import 'package:flutter/material.dart';
import 'base_controller.dart';

abstract class BaseView<T extends BaseController> extends StatelessWidget {
  final T controller;
  BaseView(this.controller);

  void _navigate({
    required BuildContext context,
    required Widget view,
    bool replace = true,
  }) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (_) => view as BaseView,
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
}
