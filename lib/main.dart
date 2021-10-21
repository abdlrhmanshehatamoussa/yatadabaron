import 'package:yatadabaron/presentation/modules/views.module.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
