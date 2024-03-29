import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrawerCustomController backend = DrawerCustomController();

    return Container(
      padding: EdgeInsets.all(0),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            FullLogo(
              padding: 20,
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              title: Text(Localization.NIGHT_MODE),
              trailing: Switch(
                onChanged: backend.toggleNightMode,
                value: backend.isNightMode(),
              ),
            ),
            Divider(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(Localization.RELEASE_NOTES),
                      trailing: Icon(
                        Icons.new_releases,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onTap: () => backend.goReleaseNotesPage(),
                    ),
                    ListTile(
                      title: Text(Localization.ABOUT),
                      trailing: Icon(
                        Icons.question_mark,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onTap: () => backend.goAboutPage(),
                    ),
                    ListTile(
                      title: Text(Localization.RATE),
                      trailing: Icon(
                        Icons.rate_review,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onTap: () async => await backend.rate(),
                    ),
                  ],
                ),
              ),
            ),
            Text(backend.versionLabel)
          ],
        ),
      ),
    );
  }
}
