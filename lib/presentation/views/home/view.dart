import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    SearchSessionController sessionBloc =
        Provider.of<SearchSessionController>(context, listen: false);
    sessionBloc.errorStream.listen((Exception e) {
      //ErrorDialog.show(context, TextProvider.SEARCH_ERROR);
    });
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
        SearchForm.show(context, sessionBloc);
      },
      child: Icon(Icons.search),
      mini: true,
    );

    Widget initialMessage = customText(Localization.TAP_SEARCH_BUTTON);
    Widget invalidSettingsMessage =
        customText(Localization.INVALID_SEARCH_SETTINGS);

    return StreamBuilder<SearchState>(
      stream: sessionBloc.stateStream,
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
          pageTitle: Localization.DRAWER_HOME,
          child: body,
          floatingButton: btn,
        );
      },
    );
  }

  static void pushReplacement(BuildContext context) {
    Navigator.of(context).pushReplacement(_getPageRoute());
  }

  static MaterialPageRoute _getPageRoute() {
    return MaterialPageRoute(
      builder: (context) => HomePage.wrappedWithProvider(),
    );
  }

  static Provider<SearchSessionController> wrappedWithProvider() {
    return Provider(
      child: HomePage(),
      create: (context) => SearchSessionController(),
    );
  }
}
