import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'controller.dart';
import './widgets/list.dart';

class MushafPage extends BaseView<MushafController> {
  MushafPage(MushafController controller) : super(controller);

  Widget _body(
    BuildContext context,
    List<Chapter> chapters,
    MushafPageState state,
  ) {
    int? highlightedVerseId;
    if (state.mode == MushafMode.BOOKMARK || state.mode == MushafMode.SEARCH) {
      highlightedVerseId = state.startFromVerse;
    }
    return Column(
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
            onItemTap: (Verse result) {
              if (result.chapterId != null) {
                navigatePush(
                  context: context,
                  view: PageRouter.instance.tafseer(
                    verseId: result.verseID,
                    chapterId: result.chapterId!,
                  ),
                );
              }
            },
          ),
          flex: 1,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              return CustomPageWrapper(
                pageTitle: Localization.DRAWER_QURAN,
                child: _body(context, chapters, state),
              );
            },
          );
        }
      },
    );
  }
}
