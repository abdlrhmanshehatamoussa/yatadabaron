import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/drawer/backend.dart';
import 'package:yatadabaron/widgets/user_avatar.dart';
import 'package:yatadabaron/widgets/module.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrawerBackend backend = DrawerBackend(context);

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
            GestureDetector(
              child: UserAvatar(user: backend.currentUser),
              onTap: backend.goAccountPage,
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
                      title: Text(Localization.RATE),
                      trailing: Icon(
                        Icons.star,
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
