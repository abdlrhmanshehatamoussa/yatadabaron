import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/bookmarks/view.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/release_notes/view.dart';
import 'package:yatadabaron/pages/search/view.dart';
import 'package:yatadabaron/pages/statistics/view.dart';
import 'package:yatadabaron/simple/module.dart';
import 'viewmodels/home_grid_item.dart';
import 'widgets/grid.dart';
import 'widgets/header.dart';

class HomePage extends SimpleView {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<HomeGridItemViewModel> _gridItems = [
      HomeGridItemViewModel(
        title: Localization.SEARCH_IN_QURAN,
        icon: Icons.search,
        onTap: () => navigatePush(
          context: context,
          view: SearchPage(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.MUSHAF_SHARIF,
        icon: Icons.book_sharp,
        onTap: () async {
          navigatePush(
            context: context,
            view: MushafPage(
              mushafSettings: null,
            ),
          );
        },
      ),
      HomeGridItemViewModel(
        title: Localization.QURAN_STATISTICS,
        icon: Icons.insert_chart_sharp,
        onTap: () => navigatePush(
          context: context,
          view: StatisticsPage(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.BOOKMARKS,
        icon: Icons.bookmark_sharp,
        onTap: () => navigatePush(
          context: context,
          view: BookmarksView(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.RELEASE_NOTES,
        icon: Icons.new_releases_rounded,
        onTap: () => navigatePush(
          context: context,
          view: ReleaseNotesPage(),
        ),
      ),
      HomeGridItemViewModel(
        title: Localization.ABOUT,
        icon: Icons.help,
        onTap: () => navigatePush(
          context: context,
          view: AboutPage(),
        ),
      ),
    ];

    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      body: Container(
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
                      size: 100,
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

  @override
  ISimpleBackend buildBackend(ISimpleServiceProvider serviceProvider) {
    throw UnimplementedError();
  }
}
