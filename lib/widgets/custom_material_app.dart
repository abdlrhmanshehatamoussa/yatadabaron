import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';

class CustomMaterialApp extends StatelessWidget {
  final ThemeData? theme;
  final Widget widget;

  const CustomMaterialApp({
    this.theme,
    required this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(),
      theme: theme,
      builder: (BuildContext context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      title: Localization.APP_TITLE,
      home: widget,
    );
  }
}
