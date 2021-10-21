import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (_) => ThemeController(),
      ),
    ],
    child: App(),
  ));
}
