import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/pages.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';
import 'list-item.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigateToMushaf(int? chapterId, int? verseId) {
      if (chapterId != null && verseId != null) {
        MushafPage.pushReplacement(context, chapterId, verseId);
      }
    }

    SearchSessionBloc sessionBloc = Provider.of<SearchSessionBloc>(context);
    return StreamBuilder<SearchSessionPayload>(
      stream: sessionBloc.payloadStream,
      builder:
          (BuildContext context, AsyncSnapshot<SearchSessionPayload> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<VerseDTO> results = snapshot.data!.results;
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
            List<VerseDTO> verses = collections[i].verses;
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
              children: verses.map((VerseDTO verse) {
                Widget? trailing;
                if(collections.length > 1){
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
                      onTap: () {
                        navigateToMushaf(verse.chapterId, verse.verseID);
                      },
                      onLongPress: () {
                        snapshot.data!.copyVerse(verse);
                      },
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
