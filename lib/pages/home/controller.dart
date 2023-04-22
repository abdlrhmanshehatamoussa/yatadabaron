import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/bookmarks/view.dart';
import 'package:yatadabaron/pages/contact/page.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/pages/search/view.dart';
import 'package:yatadabaron/pages/statistics/view.dart';

class HomeController {
  HomeController();

  void goSearchPage() {
    appNavigator.pushWidget(
      view: SearchPage(),
    );
  }

  void goMushafPage() {
    appNavigator.pushWidget(
      view: MushafPage(
        mushafSettings: null,
      ),
    );
  }

  void goStatisticsPage() {
    appNavigator.pushWidget(
      view: StatisticsPage(),
    );
  }

  void goBookmarksPage() {
    appNavigator.pushWidget(
      view: BookmarksView(),
    );
  }

  void goContactPage() {
    appNavigator.pushWidget(
      view: ContactPage(),
    );
  }
}
