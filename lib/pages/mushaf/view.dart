import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/mushaf/backend.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import '../_viewmodels/module.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
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
                height: MediaQuery.of(context).padding.top,
                child: Container(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: MushafDropDownWrapper(
                  onChapterSelected: (Chapter chapter) async =>
                      await backend.onChapterSelected(chapter),
                  chapters: state.chapters,
                  selectedChapter: state.chapter,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomStreamBuilder<bool>(
                  stream: backend.showEmla2yStream,
                  loading: LoadingWidget(),
                  done: (bool showEmla2y) {
                    return VerseList(
                      verses: state.verses,
                      highlightedVerse: highlightedVerseId,
                      startFromVerse: state.startFromVerse,
                      showEmla2y: showEmla2y,
                      iconData: icon,
                      onItemTap: backend.goTafseerPage,
                    );
                  },
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: CustomStreamBuilder<bool>(
                  stream: backend.showEmla2yStream,
                  loading: LoadingWidget(),
                  done: (bool show) {
                    return ListTile(
                      title: Text(
                        Localization.RASM_EMLA2y,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      trailing: Switch(
                        value: show,
                        onChanged: (bool v) => backend.updateShowEmla2y(v),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
