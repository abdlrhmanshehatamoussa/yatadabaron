import 'package:flutter/cupertino.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/widgets/module.dart';

import 'controller.dart';

class HomePage extends BaseView<HomeController> {
  HomePage(HomeController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return CustomPageWrapper(
      pageTitle: "Home",
      child: Container(),
      drawer: PageRouter.instance.drawer(),
    );
  }
}
