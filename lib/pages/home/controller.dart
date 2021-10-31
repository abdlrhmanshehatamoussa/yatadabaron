import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/module.dart';

class HomeController extends BaseController {
  final IAnalyticsService analyticsService;
  final IUserDataService userDataService;

  HomeController({
    required this.analyticsService,
    required this.userDataService,
  });
}
