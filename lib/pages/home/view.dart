import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
        title: Localization.SEARCH_IN_QURAN,
        icon: Icons.search,
        onTap: backend.goSearchPage,
      ),
      HomeGridItemViewModel(
        title: Localization.MUSHAF_SHARIF,
        icon: Icons.book_sharp,
        onTap: backend.goMushafPage,
      ),
      HomeGridItemViewModel(
        title: Localization.QURAN_STATISTICS,
        icon: Icons.insert_chart_sharp,
        onTap: backend.goStatisticsPage,
      ),
      HomeGridItemViewModel(
        title: Localization.BOOKMARKS,
        icon: Icons.bookmark_sharp,
        onTap: backend.goBookmarksPage,
      ),
      HomeGridItemViewModel(
        title: Localization.RELEASE_NOTES,
        icon: Icons.new_releases_rounded,
        onTap: backend.goReleaseNotesPage,
      ),
      HomeGridItemViewModel(
        title: Localization.ABOUT,
        icon: Icons.help,
        onTap: backend.goAboutPage,
      ),
      HomeGridItemViewModel(
        title: "الشكاوى و المقترحات",
        icon: Icons.telegram,
        onTap: () async {
          launchUrl(
            Uri.parse("https://t.me/+4ynYuVL39TcxNDA0"),
            mode: LaunchMode.externalApplication,
          );
        },
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
}
