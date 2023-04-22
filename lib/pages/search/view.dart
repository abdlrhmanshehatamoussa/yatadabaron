import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/search/controller.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import './widgets/search-form.dart';
import './widgets/search-results-list.dart';
import './widgets/search-summary.dart';

class SearchPage extends StatelessWidget {
  final SearchController? controller;

  const SearchPage({Key? key, this.controller}) : super(key: key);
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
    SearchController backend = controller ?? SearchController();
    backend.errorStream.listen((Exception error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    });
    Widget searchResultsArea = CustomStreamBuilder<SearchResult>(
      stream: backend.payloadStream,
      loading: LoadingWidget(),
      done: (SearchResult searchResult) {
        return Column(
          children: <Widget>[
            SearchSummaryWidget(
              searchResult: searchResult,
              onShare: (String summary) async {
                await backend.share(summary);
              },
            ),
            Divider(
              height: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              flex: 1,
              child: SearchResultsList(
                searchResult: searchResult,
                onItemLongPress: (Verse verse) async =>
                    await backend.copyVerse(verse),
                onItemPress: backend.goMushafPage,
              ),
            )
          ],
        );
      },
    );

    Widget floatingButton = FloatingActionButton(
      onPressed: () async {
        await SearchForm.show(
          context: context,
          settings: backend.settings,
          chaptersFuture: backend.getMushafChapters(),
          closeButton: true,
          onSearch: (KeywordSearchSettings settings) async {
            await backend.changeSettings(settings);
            Navigator.of(context).pop();
          },
        );
      },
      child: Icon(Icons.search),
      mini: true,
    );

    Widget invalidSettingsMessage =
        customText(Localization.INVALID_SEARCH_SETTINGS);

    return StreamBuilder<SearchState>(
      stream: backend.stateStream,
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        SearchState? state = snapshot.data;
        if (state == null) {
          return LoadingWidget();
        }
        Widget? body;
        Widget? btn = floatingButton;
        switch (state) {
          case SearchState.INITIAL:
            body = Container(
              padding: EdgeInsets.all(3),
              child: SearchForm(
                settings: backend.settings,
                chaptersFuture: backend.getMushafChapters(),
                showCloseButton: false,
                onSearch: (KeywordSearchSettings settings) async =>
                    await backend.changeSettings(settings),
              ),
            );
            btn = null;
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
        return CustomPageWrapper(
          pageTitle: Localization.SEARCH_IN_QURAN,
          child: body,
          floatingButton: btn,
          centered: false,
        );
      },
    );
  }
}
