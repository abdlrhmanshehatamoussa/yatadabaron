import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/pages/about/page.dart';
import 'package:yatadabaron/pages/bookmarks/view.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/release_notes/view.dart';
import 'package:yatadabaron/pages/search/view.dart';
import 'package:yatadabaron/pages/statistics/view.dart';

class HomeBackend {
  HomeBackend(BuildContext context);

  void goSearchPage() {
    Simply.navPush(
      view: SearchPage(),
    );
  }

  void goMushafPage() {
    Simply.navPush(
      view: MushafPage(
        mushafSettings: null,
      ),
    );
  }

  void goStatisticsPage() {
    Simply.navPush(
      view: StatisticsPage(),
    );
  }

  void goBookmarksPage() {
    Simply.navPush(
      view: BookmarksView(),
    );
  }

  void goReleaseNotesPage() {
    Simply.navPush(
      view: ReleaseNotesPage(),
    );
  }

  void goAboutPage() {
    Simply.navPush(
      view: AboutPage(),
    );
  }
}
