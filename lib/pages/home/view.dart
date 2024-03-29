import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'controller.dart';
import 'viewmodels/home_grid_item.dart';
import 'widgets/grid.dart';
import 'widgets/header.dart';

class HomePage extends StatelessWidget {
  HomePage() : super(key: UniqueKey());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    HomeController backend = HomeController();
    List<HomeGridItemViewModel> _gridItems = [
      HomeGridItemViewModel(
        title: Localization.MUSHAF_SHARIF,
        icon: Icons.book_sharp,
        onTap: backend.goMushafPage,
      ),
      HomeGridItemViewModel(
        title: Localization.BOOKMARKS,
        icon: Icons.bookmark_sharp,
        onTap: backend.goBookmarksPage,
      ),
      HomeGridItemViewModel(
        title: Localization.TARTEEL_PAGE,
        icon: Icons.headset_rounded,
        onTap: backend.goTarteelPage,
      ),
      HomeGridItemViewModel(
        title: Localization.CONTACT_US,
        icon: Icons.support_agent,
        onTap: backend.goContactPage,
      ),
    ];
    if (!kIsWeb) {
      _gridItems.insert(
        0,
        HomeGridItemViewModel(
          title: Localization.SEARCH_IN_QURAN,
          icon: Icons.search,
          onTap: backend.goSearchPage,
        ),
      );
      _gridItems.insert(
        2,
        HomeGridItemViewModel(
          title: Localization.QURAN_STATISTICS,
          icon: Icons.insert_chart_sharp,
          onTap: backend.goStatisticsPage,
        ),
      );
    }

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
}
