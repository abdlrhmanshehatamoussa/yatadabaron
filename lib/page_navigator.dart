import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:yatadabaron/presentation/modules/views.module.dart';

class PageNavigator {
  //TODO:Replace late with final
  static late IReleaseInfoService _releaseInfoService;

  static void releaseNotesReplace(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Provider(
          child: ReleaseNotesPage(),
          create: (_) => ReleaseNotesController(_releaseInfoService),
        ),
      ),
    );
  }
}
