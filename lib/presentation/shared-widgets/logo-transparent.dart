import 'package:package_info/package_info.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoTansparent extends StatelessWidget {
  TextStyle customStyle(
      {double fontSize = 47,
      FontWeight fontWeight = FontWeight.bold,
      Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Localization.APP_TITLE,
          style: customStyle(),
        ),
        Text(
          Localization.APP_DESCRIPTION,
          textAlign: TextAlign.center,
          style: customStyle(fontSize: 11, fontWeight: FontWeight.normal),
        ),
        FutureBuilder<String>(
          future: _getVersionInfo(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String info = snapshot.data ?? "";
            return Text(
              info,
              style: customStyle(fontSize: 11, fontWeight: FontWeight.normal),
            );
          },
        )
      ],
    );
  }

  Future<String> _getVersionInfo() async {
    //TODO: I'm still not happy about that
    PackageInfo _info = await PackageInfo.fromPlatform();
    String name = _info.version;
    String buildNumber = _info.buildNumber;
    return [name, buildNumber].join(" | ");
  }
}
