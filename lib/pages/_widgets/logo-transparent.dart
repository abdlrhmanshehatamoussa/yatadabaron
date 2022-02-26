import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';

class LogoTansparent extends StatelessWidget {
  final String? versionLabel;

  const LogoTansparent({
    Key? key,
    this.versionLabel,
  }) : super(key: key);

  TextStyle customStyle({
    double fontSize = 47,
    FontWeight fontWeight = FontWeight.bold,
    Color color = Colors.black,
  }) {
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
        Text(
          versionLabel ?? "",
          style: customStyle(fontSize: 11, fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}
