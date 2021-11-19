import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/mushaf/backend.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import './widgets/list.dart';

class MushafPage extends StatelessWidget {
  final MushafSettings? mushafSettings;

  MushafPage({
    required this.mushafSettings,
  });

  @override
  Widget build(BuildContext context) {
    MushafBackend backend = MushafBackend(
      mushafSettings: this.mushafSettings,
      context: context,
    );
    return Scaffold(
      body: StreamBuilder<MushafPageState>(
        stream: backend.stateStream,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top + 5,
              ),
              MushafDropDownWrapper(
                onChapterSelected: (Chapter chapter) async =>
                    await backend.onChapterSelected(chapter),
                chapters: state.chapters,
                selectedChapter: state.chapter,
                onBack: () => Navigator.of(context).pop(),
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
                  onItemTap: backend.goTafseerPage,
                ),
                flex: 1,
              )
            ],
          );
        },
      ),
    );
  }
}
