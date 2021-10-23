import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/app_start/navigation_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/mvc/base_controller.dart';
import 'package:yatadabaron/mvc/base_view.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
import 'package:yatadabaron/pages/home/view.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/release_notes/view.dart';
import 'package:yatadabaron/pages/statistics/view.dart';
import 'package:yatadabaron/widgets/module.dart';

class CustomDrawer extends BaseView<CustomDrawerController> {
  CustomDrawer(CustomDrawerController controller) : super(controller);
  @override
  Widget build(BuildContext context) {
    Icon _buildTabIcon(IconData data) {
      return Icon(
        data,
        color: Theme.of(context).colorScheme.secondary,
      );
    }

    ControllerManager manager = Provider.of<ControllerManager>(context);
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
                      title: Text(Localization.DRAWER_HOME),
                      trailing: _buildTabIcon(Icons.search),
                      onTap: () => navigateReplace(
                        context: context,
                        view: HomePage(
                          manager.homeController(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(Localization.DRAWER_QURAN),
                      trailing: _buildTabIcon(Icons.book),
                      onTap: () async {
                        int? chapterId = await controller.getSavedChapterId();
                        int? verseId = await controller.getSavedVerseId();
                        navigateReplace(
                          context: context,
                          view: MushafPage(
                            manager.mushafController(
                              chapterId: chapterId,
                              verseId: verseId,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(Localization.DRAWER_STATISTICS),
                      trailing: _buildTabIcon(Icons.insert_chart),
                      onTap: () => navigateReplace(
                        context: context,
                        view: StatisticsPage(
                          manager.statisticsController(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(Localization.RELEASE_NOTES),
                      trailing: _buildTabIcon(Icons.new_releases_rounded),
                      onTap: () => navigateReplace(
                        context: context,
                        view: ReleaseNotesPage(
                          manager.releaseNotesController(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(Localization.RATE),
                      trailing: _buildTabIcon(Icons.star),
                      onTap: () async => await controller.rate(),
                    ),
                    ListTile(
                      title: Text(Localization.ABOUT),
                      trailing: _buildTabIcon(Icons.help),
                      onTap: () => navigateReplace(
                        context: context,
                        view: AboutPage(BaseController()),
                      ),
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
}
