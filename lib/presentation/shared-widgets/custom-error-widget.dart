import 'package:Yatadabaron/crosscutting/localization.dart';
import 'package:Yatadabaron/presentation/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget errorWidget = Text(
      Localization.LOADING_ERROR,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
    );
    return Splash(errorWidget);
  }
}
