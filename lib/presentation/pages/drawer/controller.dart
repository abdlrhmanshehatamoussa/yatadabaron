import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/presentation/modules/pages.module.dart';
import 'package:yatadabaron/presentation/modules/shared-controllers.module.dart';
import 'package:yatadabaron/presentation/shared-dtos/theme-data-wrapper.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class CustomDrawerController {
  Future navigateMushafPage(BuildContext context) async {
    //Load the bookmark
    int? chapterId =
        await ServiceManager.instance.userDataService.getBookmarkChapter();
    int? verseId =
        await ServiceManager.instance.userDataService.getBookmarkVerse();
    MushafPage.pushReplacement(context, chapterId, verseId);
  }

  Future rate() async {
    ServiceManager.instance.analyticsService
        .logOnTap("DRAWER", payload: "TAB=RATE");
    await LaunchReview.launch();
  }

  void navigateHelpPage(BuildContext context) {
    ServiceManager.instance.analyticsService
        .logOnTap("DRAWER", payload: "TAB=ABOUT");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => AboutPage(),
    ));
  }

  void navigateHomePage(BuildContext context) {
    HomePage.pushReplacement(context);
  }

  void navigateStatisticsPage(BuildContext context) {
    StatisticsPage.pushReplacement(context);
  }

  void navigateNewFeatures(BuildContext context) {
    ReleaseNotesPage.pushReplacement(context);
  }

  void toggleNightMode(bool mode, ThemeController bloc) {
    if (mode == true) {
      bloc.updateTheme(ThemeDataWrapper.dark());
    } else {
      bloc.updateTheme(ThemeDataWrapper.light());
    }
    ServiceManager.instance.userDataService.setNightMode(mode);
  }

  bool isNightMode(ThemeController bloc) {
    return (bloc.currentTheme != null) &&
        (bloc.currentTheme!.appTheme == AppTheme.DARK);
  }
}
