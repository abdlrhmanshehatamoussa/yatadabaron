import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/presentation/about/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:Yatadabaron/presentation/mushaf/bloc.dart';
import 'package:Yatadabaron/presentation/home/bloc.dart';
import 'package:Yatadabaron/presentation/statistics/bloc.dart';
import '../../presentation/home/page.dart';
import '../../presentation/mushaf/page.dart';
import '../../presentation/shared-widgets/full-logo.dart';
import '../../presentation/shared-widgets/transparent-bar.dart';
import '../../presentation/statistics/page.dart';

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
                    await ServiceManager.instance.userDataService.getBookmarkChapter();
                int? verseId =
                    await ServiceManager.instance.userDataService.getBookmarkVerse();
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
                ServiceManager.instance.analyticsService.logOnTap("DRAWER", payload: "TAB=RATE");
                LaunchReview.launch();
              },
            ),
            ListTile(
              title: Text(Localization.ABOUT),
              trailing: Icon(Icons.help),
              onTap: () {
                ServiceManager.instance.analyticsService.logOnTap("DRAWER", payload: "TAB=ABOUT");
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
