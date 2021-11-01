import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends SimpleView {
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
      Localization.TAFSEER_ABOUT
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

  @override
  ISimpleController provideController(ISimpleServiceProvider serviceProvider) {
    throw UnimplementedError();
  }
}
