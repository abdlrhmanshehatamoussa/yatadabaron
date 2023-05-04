import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';

class SearchSummaryWidget extends StatelessWidget {
  final SearchResult searchResult;
  final Function(String summary) onShare;

  const SearchSummaryWidget({
    required this.searchResult,
    required this.onShare,
  });

  String _natigaTamyeez(int count) {
    return Utils.numberTamyeez(
      count: count,
      isMasculine: false,
      mothana: Localization.RESULT_MOTHANA,
      plural: Localization.RESULT_PLURAL,
      single: Localization.RESULT,
    );
  }

  String _suraTamyeez(int count) {
    return Utils.numberTamyeez(
      count: count,
      single: Localization.SURA_SINGLE,
      plural: Localization.SURA_PLURAL,
      mothana: Localization.SURA_MOTHANA,
      isMasculine: false,
    );
  }

  String get summary {
    if (searchResult.collections.isEmpty) {
      return Localization.EMPTY_SEARCH_RESULTS;
    }
    int chaptersCount = searchResult.collections.length;
    bool wholeQuran = searchResult.settings.searchInWholeQuran;
    String result = _natigaTamyeez(searchResult.totalMatchCount);
    String foundIn;
    if (wholeQuran) {
      foundIn = _suraTamyeez(chaptersCount);
    } else {
      foundIn = searchResult.results.first.verse.chapterName!;
    }
    return Utils.replaceMultiple(
      Localization.SEARCH_SUMMARY,
      "#",
      [
        result,
        searchResult.settings.keyword,
        foundIn,
        searchResult.settings.mode.name,
      ],
    );
  }

  String get toShare {
    String toCopy = "$summary\n\n";
    searchResult.results.forEach((VerseSearchResult verseSearchResult) {
      toCopy += "${verseSearchResult.verse.toString()}\n";
    });
    return toCopy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              summary,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: "Arial",
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              child: Icon(Icons.share),
              onPressed: () async => await this.onShare(toShare),
              mini: true,
              heroTag: null,
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
