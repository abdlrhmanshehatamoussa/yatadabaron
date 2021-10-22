import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/widgets/module.dart';

import './widgets/search-form.dart';
import './widgets/search-results-list.dart';
import './widgets/search-summary.dart';
import 'controller.dart';

class HomePage extends StatelessWidget {
  Widget customText(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Utils.emptyListStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ControllerManager manager = Provider.of<ControllerManager>(context);
    HomeController controller = Provider.of<HomeController>(context, listen: false);
    Widget searchResultsArea = Column(
      children: <Widget>[
        SearchSummaryWidget(),
        Divider(
          height: 5,
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          flex: 1,
          child: SearchResultsList(),
        )
      ],
    );

    Widget floatingButton = FloatingActionButton(
      onPressed: () {
        SearchForm.show(context, controller);
      },
      child: Icon(Icons.search),
      mini: true,
    );

    Widget initialMessage = customText(Localization.TAP_SEARCH_BUTTON);
    Widget invalidSettingsMessage =
        customText(Localization.INVALID_SEARCH_SETTINGS);

    return StreamBuilder<SearchState>(
      stream: controller.stateStream,
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        SearchState? state = snapshot.data;
        Widget? body;
        Widget? btn = floatingButton;
        switch (state) {
          case SearchState.INITIAL:
            body = initialMessage;
            break;
          case SearchState.IN_PROGRESS:
            body = LoadingWidget();
            btn = null;
            break;
          case SearchState.DONE:
            body = searchResultsArea;
            break;
          case SearchState.INVALID_SETTINGS:
            body = invalidSettingsMessage;
            break;
          default:
            break;
        }
        if (state == null) {
          return LoadingWidget();
        }
        return CustomPageWrapper(
          drawer: Provider(
            create: (_) => manager.drawerController(),
            child: CustomDrawer(),
          ),
          pageTitle: Localization.DRAWER_HOME,
          child: body,
          floatingButton: btn,
        );
      },
    );
  }
}
