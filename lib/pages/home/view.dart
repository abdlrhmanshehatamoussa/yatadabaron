import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'viewmodels/home_grid_item.dart';
import 'controller.dart';
import 'widgets/grid.dart';
import 'widgets/header.dart';

class HomePage extends BaseView<HomeController> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  HomePage(HomeController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    List<HomeGridItemViewModel> _gridItems = [
      HomeGridItemViewModel(
        title: Localization.DRAWER_SEARCH,
        icon: Icons.search,
        onTap: () => navigatePush(
          context: context,
          view: PageRouter.instance.search(),
        ),
      ),
      HomeGridItemViewModel(
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
      HomeGridItemViewModel(
        title: Localization.DRAWER_STATISTICS,
        icon: Icons.insert_chart,
        onTap: () => navigatePush(
          context: context,
          view: PageRouter.instance.statistics(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.RELEASE_NOTES,
        icon: Icons.new_releases_rounded,
        onTap: () => navigatePush(
          context: context,
          view: PageRouter.instance.releaseNotes(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.ABOUT,
        icon: Icons.help,
        onTap: () => navigatePush(
          context: context,
          view: PageRouter.instance.about(),
        ),
      ),
    ];

    Color? mainContainerColor = Theme.of(context).cardColor;
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: PageRouter.instance.drawer(),
      ),
      body: Container(
        color: mainContainerColor,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
              child: null,
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 3, right: 3),
                child: Column(
                  children: <Widget>[
                    HomeHeader(
                      size: 120,
                      drawerOnTap: () => _key.currentState!.openDrawer(),
                    ),
                    Expanded(
                      child: HomeGrid(
                        items: _gridItems,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
