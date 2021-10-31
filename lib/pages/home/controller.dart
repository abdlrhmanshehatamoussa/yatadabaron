import 'package:yatadabaron/services/interfaces/module.dart';

class HomeController{
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;

  HomeController({
    required this.analyticsService,
    required this.userDataService,
  });
}
