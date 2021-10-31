import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class CustomDrawer extends SimpleView {
  @override
  Widget build(BuildContext context) {
    IVersionInfoService versionInfoService =
        getService<IVersionInfoService>(context);

    CustomDrawerController controller = CustomDrawerController(
      analyticsService: getService<IAnalyticsService>(context),
      userDataService: getService<IUserDataService>(context),
      releaseInfoService: getService<IReleaseInfoService>(context),
    );

    Icon _buildTabIcon(IconData data) {
      return Icon(
        data,
        color: Theme.of(context).colorScheme.secondary,
      );
    }

    String currentVersion = versionInfoService.getVersionName();
    String versionLabel =
        [Localization.RELEASE_NAME, currentVersion].join(" : ");
    return Container(
      padding: EdgeInsets.all(0),
      child: Center(
        child: Column(
          children: <Widget>[
            TransparentTopBar(),
            FullLogo(
              padding: 20,
            ),
            ListTile(
              title: Text(Localization.NIGHT_MODE),
              trailing: Switch(
                onChanged: (bool mode) => controller.toggleNightMode(mode),
                value: controller.isNightMode(),
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
                      trailing: _buildTabIcon(Icons.star),
                      onTap: () async => await controller.rate(),
                    ),
                  ],
                ),
              ),
            ),
            Text(versionLabel)
          ],
        ),
      ),
    );
  }
}
