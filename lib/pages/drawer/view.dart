import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/pages/drawer/controller.dart';
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

    return Container(
      padding: EdgeInsets.all(0),
      child: Center(
        child: Column(
          children: <Widget>[
            TransparentTopBar(),
            FullLogo(
              padding: 40,
              versionLabel: controller.versionLabel,
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
                      title: Text(Localization.DRAWER_SEARCH),
                      trailing: _buildTabIcon(Icons.search),
                      onTap: () => navigateReplace(
                        context: context,
                        view: PageRouter.instance.search(),
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
                          view: PageRouter.instance.mushaf(
                            chapterId: chapterId,
                            verseId: verseId,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(Localization.DRAWER_STATISTICS),
                      trailing: _buildTabIcon(Icons.insert_chart),
                      onTap: () => navigateReplace(
                        context: context,
                        view: PageRouter.instance.statistics(),
                      ),
                    ),
                    ListTile(
                      title: Text(Localization.RELEASE_NOTES),
                      trailing: _buildTabIcon(Icons.new_releases_rounded),
                      onTap: () => navigateReplace(
                        context: context,
                        view: PageRouter.instance.releaseNotes(),
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
                        view: PageRouter.instance.about(),
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
