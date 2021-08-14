import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  Widget customText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget customDivider() {
    return Divider(height: 10, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    List<String> statements = [
      Localization.APP_DESCRIPTION,
      Localization.MUSHAF_DESCRIPTION,
    ];
    return CustomPageWrapper(
      pageTitle: Localization.ABOUT,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: ListView.separated(
            itemBuilder: (_, int i) {
              String text = statements[i];
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
