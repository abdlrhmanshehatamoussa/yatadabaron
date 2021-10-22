import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import '../controller.dart';
import 'list-item.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ControllerManager manager = Provider.of<ControllerManager>(context);
    HomeController controller = manager.homeController();
    return StreamBuilder<SearchSessionPayload>(
      stream: controller.payloadStream,
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
                      onTap: () {
                        int? chapterId = verse.chapterId;
                        int? verseID = verse.verseID;
                        if (chapterId != null && verseID != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Provider(
                                child: MushafPage(),
                                create: (_)=>manager.mushafController(
                                  chapterId: chapterId,
                                  verseId: verseID
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () async {
                        await controller.copyVerse(verse);
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
