import 'package:yatadabaron/presentation/modules/pages.module.dart';
import 'package:yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (_) => ThemeBloc(),
      ),
    ],
    child: App(),
  ));
}
