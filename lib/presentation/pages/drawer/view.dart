import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/presentation/modules/shared-controllers.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:provider/provider.dart';
import 'controller.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomDrawerController drawerBloc = Provider.of<CustomDrawerController>(context);
    ThemeController themeBloc = Provider.of<ThemeController>(context);
    Icon _buildTabIcon(IconData data) {
      return Icon(
        data,
        color: Theme.of(context).colorScheme.secondary,
      );
    }

    return Container(
      padding: EdgeInsets.all(0),
      child: Center(
        child: Column(
          children: <Widget>[
            TransparentTopBar(),
            FullLogo(
              padding: 40,
            ),
            ListTile(
              title: Text(Localization.NIGHT_MODE),
              trailing: Switch(
                onChanged: (bool mode) =>
                    drawerBloc.toggleNightMode(mode, themeBloc),
                value: drawerBloc.isNightMode(themeBloc),
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
                      title: Text(Localization.DRAWER_HOME),
                      trailing: _buildTabIcon(Icons.search),
                      onTap: () => drawerBloc.navigateHomePage(context),
                    ),
                    ListTile(
                      title: Text(Localization.DRAWER_QURAN),
                      trailing: _buildTabIcon(Icons.book),
                      onTap: () async =>
                          await drawerBloc.navigateMushafPage(context),
                    ),
                    ListTile(
                      title: Text(Localization.DRAWER_STATISTICS),
                      trailing: _buildTabIcon(Icons.insert_chart),
                      onTap: () => drawerBloc.navigateStatisticsPage(context),
                    ),
                    ListTile(
                      title: Text(Localization.RELEASE_NOTES),
                      trailing: _buildTabIcon(Icons.new_releases_rounded),
                      onTap: () => drawerBloc.navigateNewFeatures(context),
                    ),
                    ListTile(
                      title: Text(Localization.RATE),
                      trailing: _buildTabIcon(Icons.star),
                      onTap: () async => await drawerBloc.rate(),
                    ),
                    ListTile(
                      title: Text(Localization.ABOUT),
                      trailing: _buildTabIcon(Icons.help),
                      onTap: () => drawerBloc.navigateHelpPage(context),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Provider<CustomDrawerController> providedWithBloc() {
    return Provider(
      create: (_) => CustomDrawerController(),
      child: CustomDrawer(),
    );
  }
}
