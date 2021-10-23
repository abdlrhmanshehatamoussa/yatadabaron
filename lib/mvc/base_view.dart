import 'package:flutter/material.dart';
import 'package:yatadabaron/mvc/base_controller.dart';

abstract class BaseView<T extends BaseController> extends StatelessWidget {
  final T controller;
  BaseView(this.controller);

  _navigate({
    required BuildContext context,
    required BaseView view,
    bool replace = true,
  }) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (_) => view,
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  navigatePush({
    required BuildContext context,
    required BaseView view,
  }) {
    _navigate(
      context: context,
      view: view,
      replace: false,
    );
  }

  navigateReplace({
    required BuildContext context,
    required BaseView view,
  }) {
    _navigate(
      context: context,
      view: view,
      replace: true,
    );
  }
}
