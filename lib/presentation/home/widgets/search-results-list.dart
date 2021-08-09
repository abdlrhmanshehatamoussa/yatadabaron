import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/shared-widgets.module.dart';
import 'package:Yatadabaron/presentation/mushaf/bloc.dart';
import 'package:Yatadabaron/presentation/mushaf/page.dart';
import 'package:Yatadabaron/presentation/home/widgets/list-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';


class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigateToMushaf(int? chapterId, int? verseId) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) {
          return Provider(
            child: MushafPage(),
            create: (_) => MushafBloc(chapterId, verseId),
          );
        }),
      );
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
        if (collections.length == 1) {
          return ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(
              thickness: 1,
            ),
            itemBuilder: (_, i) {
              VerseDTO verse = results[i];

              return ListTile(
                title: SearchResultsListItem(
                  verseTextTashkel: verse.verseTextTashkel,
                  verseID: verse.verseID,
                  keyword: settings.keyword,
                  onlyIfExact: settings.mode == SearchMode.WORD,
                  verseText: verse.verseText,
                  matchColor: Theme.of(context).accentColor,
                ),
                onTap: () {
                  snapshot.data!.copyVerse(verse);
                },
              );
            },
          );
        }
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
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: SearchResultsListItem(
                        verseTextTashkel: verse.verseTextTashkel,
                        verseID: verse.verseID,
                        verseText: verse.verseText,
                        keyword: settings.keyword,
                        onlyIfExact: settings.mode == SearchMode.WORD,
                        matchColor: Theme.of(context).accentColor,
                      ),
                      trailing: Text(verse.chapterName!),
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
