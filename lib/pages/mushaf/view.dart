import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import './widgets/list.dart';

class MushafPage extends SimpleView<MushafController> {
  final MushafSettings? mushafSettings;

  MushafPage({
    required this.mushafSettings,
  });

  @override
  Widget build(BuildContext context) {
    MushafController controller = getController(context);
    controller.reloadVerses(this.mushafSettings);
    return FutureBuilder<List<Chapter>>(
      future: controller.getChaptersSimple,
      builder: (_, chaptersSnapshot) {
        if (!chaptersSnapshot.hasData) {
          return LoadingWidget();
        } else {
          List<Chapter> chapters = chaptersSnapshot.data!;
          return StreamBuilder<MushafPageState>(
            stream: controller.stateStream,
            builder: (_, stateSnapshot) {
              if (!stateSnapshot.hasData) {
                return LoadingWidget();
              }
              MushafPageState state = stateSnapshot.data!;
              int? highlightedVerseId;
              IconData? icon;
              if (state.mode == MushafMode.BOOKMARK ||
                  state.mode == MushafMode.SEARCH) {
                highlightedVerseId = state.startFromVerse;
                if (state.mode == MushafMode.BOOKMARK) {
                  icon = Icons.bookmark_added_sharp;
                } else {
                  icon = Icons.search_sharp;
                }
              }
              return CustomPageWrapper(
                pageTitle: Localization.MUSHAF_SHARIF,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MushafDropDownWrapper(
                      onChapterSelected: (Chapter chapter) async =>
                          await controller.onChapterSelected(chapter),
                      chapters: chapters,
                      selectedChapter: state.chapter,
                    ),
                    Divider(
                      height: 5,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Expanded(
                      child: VerseList(
                        verses: state.verses,
                        highlightedVerse: highlightedVerseId,
                        startFromVerse: state.startFromVerse,
                        icon: icon,
                        onItemTap: (Verse result) {
                          if (result.chapterId != null) {
                            navigatePush(
                              context: context,
                              view: TafseerPage(
                                location: MushafLocation(
                                  verseId: result.verseID,
                                  chapterId: result.chapterId!,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      flex: 1,
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  MushafController provideController(ISimpleServiceProvider serviceProvider) {
    return MushafController(
      analyticsService: serviceProvider.getService<IAnalyticsService>(),
      chaptersService: serviceProvider.getService<IChaptersService>(),
      userDataService: serviceProvider.getService<IUserDataService>(),
      versesService: serviceProvider.getService<IVersesService>(),
    );
  }
}
