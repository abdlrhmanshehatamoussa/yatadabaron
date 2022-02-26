import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import 'package:yatadabaron/simple/backend.dart';

class AboutPageBackend extends SimpleBackend {
  AboutPageBackend(BuildContext myContext) : super(myContext);
  late IVersionInfoService versionInfoService =
      getService<IVersionInfoService>();
  String get buildId => versionInfoService.getBuildId();
}
