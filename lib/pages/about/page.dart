import 'package:provider/provider.dart';
import 'package:yatadabaron/app_start/navigation_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/mvc/base_controller.dart';
import 'package:yatadabaron/mvc/base_view.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends BaseView {
  AboutPage(BaseController controller) : super(controller);

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
    ControllerManager manager = Provider.of<ControllerManager>(context);
    List<String> statements = [
      Localization.APP_DESCRIPTION,
      Localization.MUSHAF_DESCRIPTION,
      Localization.TAFSEER_ABOUT
    ];
    return CustomPageWrapper(
      drawer: CustomDrawer(manager.drawerController()),
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
