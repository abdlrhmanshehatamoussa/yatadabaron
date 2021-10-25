import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'list-item.dart';

class SearchResultsList extends StatelessWidget {
  final Stream<SearchSessionPayload> payloadStream;
  final Function(Verse verse) onItemPress;
  final Function(Verse verse) onItemLongPress;

  const SearchResultsList({
    required this.payloadStream,
    required this.onItemPress,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchSessionPayload>(
      stream: this.payloadStream,
      builder:
          (BuildContext context, AsyncSnapshot<SearchSessionPayload> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<Verse> results = snapshot.data!.results;
        SearchSettings settings = snapshot.data!.settings;
        if (results.length == 0) {
          return Center(
            child: Text(
              Localization.EMPTY_SEARCH_RESULTS,
              style: Utils.emptyListStyle(),
            ),
          );
        }
        List<VerseCollection> collections = snapshot.data!.verseCollections;
        return ListView.builder(
          itemCount: collections.length,
          itemBuilder: (BuildContext context, int i) {
            String? collectionName = collections[i].collectionName;
            List<Verse> verses = collections[i].verses;
            String? versesCountArabic = Utils.numberTamyeez(
                single: Localization.VERSE,
                plural: Localization.VERSES,
                count: verses.length,
                mothana: Localization.VERSE_MOTHANA,
                isMasculine: false);
            return ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "$collectionName [$versesCountArabic]",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Arial",
                  fontSize: 13,
                ),
              ),
              children: verses.map((Verse verse) {
                Widget? trailing;
                if (collections.length > 1) {
                  trailing = Text(verse.chapterName!);
                }
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: SearchResultsListItem(
                        verseTextTashkel: verse.verseTextTashkel,
                        verseID: verse.verseID,
                        verseText: verse.verseText,
                        keyword: settings.keyword,
                        onlyIfExact: settings.mode == SearchMode.WORD,
                        matchColor: Theme.of(context).colorScheme.secondary,
                      ),
                      trailing: trailing,
                      onTap: () => this.onItemPress(verse),
                      onLongPress: () => this.onItemLongPress(verse),
                    ),
                    Divider(
                      thickness: 1,
                    )
                  ],
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
