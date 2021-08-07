import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/persistence.module.dart';
import 'package:Yatadabaron/presentation/about/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:Yatadabaron/presentation/mushaf/viewmodel.dart';
import 'package:Yatadabaron/presentation/home/viewmodel.dart';
import 'package:Yatadabaron/presentation/statistics/viewmodel.dart';
import '../../presentation/home/view.dart';
import '../../presentation/mushaf/view.dart';
import '../../presentation/shared-widgets/full-logo.dart';
import '../../presentation/shared-widgets/transparent-bar.dart';
import '../../presentation/statistics/view.dart';

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
                //Load the bookmark
                int? chapterId =
                    await UserDataRepository.instance.getBookmarkChapter();
                int? verseId =
                    await UserDataRepository.instance.getBookmarkVerse();
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
                AnalyticsService.instance.logOnTap("DRAWER", payload: "TAB=RATE");
                LaunchReview.launch();
              },
            ),
            ListTile(
              title: Text(Localization.ABOUT),
              trailing: Icon(Icons.help),
              onTap: () {
                AnalyticsService.instance.logOnTap("DRAWER", payload: "TAB=ABOUT");
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
