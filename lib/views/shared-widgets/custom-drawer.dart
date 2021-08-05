import 'package:Yatadabaron/services/analytics-service.dart';
import 'package:Yatadabaron/services/custom-prefs.dart';
import 'package:Yatadabaron/views/about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../blocs/search-session-bloc.dart';
import '../../blocs/statistics-bloc.dart';
import '../../helpers/localization.dart';
import '../../views/home/home.dart';
import '../../views/mushaf/mushaf.dart';
import '../../views/shared-widgets/full-logo.dart';
import '../../views/shared-widgets/transparent-bar.dart';
import '../../views/statistics/statistics.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              title: Text(Localization.DRAWER_HOME),
              trailing: Icon(Icons.search),
              onTap: () {
                AnalyticsService.instance.logOnTap("DRAWER HOME");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Provider(
                    child: HomePage(),
                    create: (contextt) => SearchSessionBloc(),
                  ),
                ));
              },
            ),
            ListTile(
              title: Text(Localization.DRAWER_QURAN),
              trailing: Icon(Icons.book),
              onTap: () async {
                AnalyticsService.instance.logOnTap("DRAWER MUSHAF");
                //Load the bookmark
                int? chapterId =
                    await CustomSharedPreferences.instance.getBookmarkChapter();
                int? verseId =
                    await CustomSharedPreferences.instance.getBookmarkVerse();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Provider(
                    child: MushafPage(),
                    create: (contextt) => MushafBloc(chapterId, verseId),
                  ),
                ));
              },
            ),
            ListTile(
              title: Text(Localization.DRAWER_STATISTICS),
              trailing: Icon(Icons.insert_chart),
              onTap: () {
                AnalyticsService.instance.logOnTap("DRAWER STATISTICS");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Provider(
                    child: StatisticsPage(),
                    create: (contextt) => StatisticsBloc(),
                  ),
                ));
              },
            ),
            ListTile(
              title: Text(Localization.RATE),
              trailing: Icon(Icons.star),
              onTap: () {
                AnalyticsService.instance.logOnTap("DRAWER RATE");
                LaunchReview.launch();
              },
            ),
            ListTile(
              title: Text(Localization.ABOUT),
              trailing: Icon(Icons.help),
              onTap: () {
                AnalyticsService.instance.logOnTap("DRAWER ABOUT");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
