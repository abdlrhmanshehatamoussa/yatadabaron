import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'list-item.dart';

class SearchResultsList extends StatelessWidget {
  final SearchResult searchResult;
  final Function(Verse verse) onItemPress;
  final Function(Verse verse) onItemLongPress;

  const SearchResultsList({
    required this.searchResult,
    required this.onItemPress,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (searchResult.collections.isEmpty) {
      return Center(
        child: Text(
          Localization.EMPTY_SEARCH_RESULTS,
          style: Utils.emptyListStyle(),
        ),
      );
    }
    List<VerseCollection> collections = searchResult.collections;
    return ListView.builder(
      itemCount: collections.length,
      itemBuilder: (BuildContext context, int i) {
        VerseCollection collection = collections[i];
        String? collectionName = collection.collectionName;

        String? resultsCountArabic = Utils.numberTamyeez(
          count: collection.resultsCount,
          single: Localization.RESULT,
          plural: Localization.RESULT_PLURAL,
          mothana: Localization.RESULT_MOTHANA,
          isMasculine: false,
        );
        String? versesCountArabic = Utils.numberTamyeez(
          count: collection.results.length,
          single: Localization.VERSE,
          plural: Localization.VERSE_PLURAL,
          mothana: Localization.VERSE_MOTHANA,
          isMasculine: false,
        );
        return ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            "$collectionName  [$resultsCountArabic ${Localization.IN} $versesCountArabic]",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Arial",
              fontSize: 13,
            ),
          ),
          children:
              collection.results.map((VerseSearchResult verseSearchResult) {
            String verseIdStr =
                Utils.convertToArabiNumber(verseSearchResult.verse.verseID);
            return Column(
              children: <Widget>[
                ListTile(
                  title: SearchResultsListItem(
                    slices: verseSearchResult.slices,
                    matchColor: Theme.of(context).colorScheme.secondary,
                    verseId: verseIdStr,
                  ),
                  subtitle: Text(
                    verseSearchResult.verse.chapterName!,
                    style: TextStyle(fontSize: 16, fontFamily: "Usmani"),
                  ),
                  onTap: () => this.onItemPress(verseSearchResult.verse),
                  onLongPress: () =>
                      this.onItemLongPress(verseSearchResult.verse),
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
  }
}
