import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:simply/simply.dart';

class AboutPageBackend extends SimpleBackend {
  AboutPageBackend(BuildContext myContext) : super(myContext);
  late IVersionInfoService versionInfoService =
      getService<IVersionInfoService>();
  String get buildId => versionInfoService.getBuildId();
}
