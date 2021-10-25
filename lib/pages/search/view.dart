import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import './widgets/search-form.dart';
import './widgets/search-results-list.dart';
import './widgets/search-summary.dart';
import 'controller.dart';

class SearchPage extends BaseView<SearchController> {
  SearchPage(controller) : super(controller);

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
    Widget searchResultsArea = Column(
      children: <Widget>[
        SearchSummaryWidget(
          payloadStream: controller.payloadStream,
          onPressed: (SearchSessionPayload payload) async {
            await controller.copyAll(payload);
          },
        ),
        Divider(
          height: 5,
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          flex: 1,
          child: SearchResultsList(
            payloadStream: this.controller.payloadStream,
            onItemLongPress: (Verse verse) async =>
                await controller.copyVerse(verse),
            onItemPress: (Verse verse) async {
              int? chapterId = verse.chapterId;
              int? verseID = verse.verseID;
              if (chapterId != null) {
                navigatePush(
                  context: context,
                  view: PageRouter.instance.mushaf(
                    chapterId: chapterId,
                    verseId: verseID,
                  ),
                );
              }
            },
          ),
        )
      ],
    );

    Widget floatingButton = FloatingActionButton(
      onPressed: () async {
        await SearchForm.show(
          context: context,
          chaptersFuture: controller.getMushafChapters(),
          onSearch: (SearchSettings settings) async {
            await controller.changeSettings(settings);
          },
        );
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
          drawer: PageRouter.instance.drawer(),
          pageTitle: Localization.DRAWER_SEARCH,
          child: body,
          floatingButton: btn,
        );
      },
    );
  }
}
