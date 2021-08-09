import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/presentation/modules/pages.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:Yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DrawerBloc drawerBloc = Provider.of<DrawerBloc>(context);
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
              title: Text(Localization.DRAWER_HOME),
              trailing: _buildTabIcon(Icons.search),
              onTap: () => drawerBloc.navigateHomePage(context),
            ),
            ListTile(
              title: Text(Localization.DRAWER_QURAN),
              trailing: _buildTabIcon(Icons.book),
              onTap: () async => await drawerBloc.navigateMushafPage(context),
            ),
            ListTile(
              title: Text(Localization.DRAWER_STATISTICS),
              trailing: _buildTabIcon(Icons.insert_chart),
              onTap: () =>drawerBloc.navigateStatisticsPage(context),
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
            ),
          ],
        ),
      ),
    );
  }

  static Provider<DrawerBloc> providedWithBloc() {
    return Provider(
      create: (_) => DrawerBloc(),
      child: CustomDrawer(),
    );
  }
}
