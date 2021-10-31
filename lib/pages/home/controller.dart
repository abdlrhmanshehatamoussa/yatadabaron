import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';

class HomeController implements ISimpleController {
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;

  HomeController({
    required this.analyticsService,
    required this.userDataService,
  });
}