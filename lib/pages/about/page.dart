import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'backend.dart';

class AboutPage extends StatelessWidget {
  Widget customText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget customDivider() {
    return Divider(height: 10, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    AboutPageBackend backend = AboutPageBackend(context);
    List<String> statements = [
      Localization.APP_DESCRIPTION,
      Localization.MUSHAF_DESCRIPTION,
      Localization.TAFSEER_ABOUT,
      (Localization.VERSION_BUILD_ID).replaceFirst("#", backend.buildId),
    ];
    return CustomPageWrapper(
      pageTitle: Localization.ABOUT,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: ListView.separated(
            itemBuilder: (_, int i) {
              String text = "- ${statements[i]}";
              return customText(text);
            },
            separatorBuilder: (_, __) {
              return customDivider();
            },
            itemCount: statements.length,
          ),
        ),
      ),
      floatingButton: null,
    );
  }
}
