import 'package:flutter/material.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/bookmarks/view.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/release_notes/view.dart';
import 'package:yatadabaron/pages/search/view.dart';
import 'package:yatadabaron/pages/statistics/view.dart';
import 'package:yatadabaron/simple/module.dart';

class HomeBackend extends SimpleBackend {
  HomeBackend(BuildContext context) : super(context);

  void goSearchPage() {
    navigatePush(
      view: SearchPage(),
    );
  }

  void goMushafPage() {
    navigatePush(
      view: MushafPage(
        mushafSettings: null,
      ),
    );
  }

  void goStatisticsPage() {
    navigatePush(
      view: StatisticsPage(),
    );
  }

  void goBookmarksPage() {
    navigatePush(
      view: BookmarksView(),
    );
  }

  void goReleaseNotesPage() {
    navigatePush(
      view: ReleaseNotesPage(),
    );
  }

  void goAboutPage() {
    navigatePush(
      view: AboutPage(),
    );
  }
}
