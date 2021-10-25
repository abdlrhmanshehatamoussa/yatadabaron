import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/widgets/module.dart';

import 'controller.dart';

class HomePage extends BaseView<HomeController> {
  HomePage(HomeController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    Widget _gridIcon({
      required String title,
      required IconData icon,
      required Function onTap,
    }) {
      return GestureDetector(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Icon(icon,
                    size: 35, color: Theme.of(context).colorScheme.secondary),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
        onTap: () => onTap(),
      );
    }

    return CustomPageWrapper(
      drawer: PageRouter.instance.drawer(),
      pageTitle: Localization.APP_TITLE,
      child: Container(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          children: [
            _gridIcon(
              title: Localization.DRAWER_SEARCH,
              icon: Icons.search,
              onTap: () => navigatePush(
                context: context,
                view: PageRouter.instance.search(),
              ),
            ),
            _gridIcon(
              title: Localization.DRAWER_QURAN,
              icon: Icons.book,
              onTap: () async {
                int? chapterId = await controller.getSavedChapterId();
                int? verseId = await controller.getSavedVerseId();

                navigatePush(
                  context: context,
                  view: PageRouter.instance.mushaf(
                    chapterId: chapterId,
                    verseId: verseId,
                  ),
                );
              },
            ),
            _gridIcon(
              title: Localization.DRAWER_STATISTICS,
              icon: Icons.insert_chart,
              onTap: () => navigatePush(
                context: context,
                view: PageRouter.instance.statistics(),
              ),
            ),
            _gridIcon(
              title: Localization.RELEASE_NOTES,
              icon: Icons.new_releases_rounded,
              onTap: () => navigatePush(
                context: context,
                view: PageRouter.instance.releaseNotes(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
