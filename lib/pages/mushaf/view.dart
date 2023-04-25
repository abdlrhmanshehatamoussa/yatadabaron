import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
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
    if (mushafSettings == null || mushafSettings!.mode == MushafMode.BOOKMARK) {
      Future.delayed(
        Duration.zero,
        () async => await Utils.showFeatureUpdateDialog(
          updateId: "mushaf_searchwhilereading_1",
          context: context,
          title: "آخر التحديثات",
          imageUrl:
              "https://raw.githubusercontent.com/abdlrhmanshehatamoussa/yatadabaron-assets/main/verse-search.jfif",
          body: "* اضغط ضغطة مُطَوَّلة على الآية للمشاركة"
              "\n"
              "* اضغط مرتين على أي كلمة في الآية (الرسم الإملائي وليس العثماني) للبحث عنها في المصحف الشريف, كما هو موضح:",
        ),
      );
    }
    MushafController backend = MushafController(
      mushafSettings: this.mushafSettings,
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
                child: VerseList(
                  verses: state.verses,
                  highlightedVerse: highlightedVerseId,
                  startFromVerse: state.startFromVerse,
                  searchable: state.mode != MushafMode.SEARCH,
                  iconData: icon,
                  onItemTap: backend.goTafseerPage,
                  onItemLongTap: (v) async => await backend.shareVerse(v),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
