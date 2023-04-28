import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import '../_viewmodels/module.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import './widgets/list.dart';

class MushafPage extends StatefulWidget {
  final MushafSettings? mushafSettings;

  MushafPage({
    required this.mushafSettings,
  });

  @override
  State<StatefulWidget> createState() => _MushafPageState();
}

class _MushafPageState extends State<MushafPage> {
  List<int> selectedIds = [];
  @override
  Widget build(BuildContext context) {
    if (widget.mushafSettings == null ||
        widget.mushafSettings!.mode == MushafMode.BOOKMARK) {
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
      mushafSettings: widget.mushafSettings,
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
                  onItemTap: (v) {
                    if (selectedIds.isEmpty) {
                      backend.goTafseerPage(v);
                    } else {
                      setState(() {
                        if (selectedIds.contains(v.verseID)) {
                          selectedIds.remove(v.verseID);
                        } else {
                          selectedIds.add(v.verseID);
                        }
                      });
                    }
                  },
                  onItemLongTap: selectedIds.isEmpty
                      ? (v) {
                          setState(
                            () {
                              selectedIds.add(v.verseID);
                            },
                          );
                        }
                      : (v) {},
                  selectedVerses: selectedIds,
                ),
              ),
              selectedIds.isNotEmpty
                  ? Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "تم تحديد"
                              " ("
                              "${Utils.convertToArabiNumber(selectedIds.length)}"
                              ")",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            TextButton(
                              onPressed: () async {
                                await backend.shareVerses(state.verses
                                    .where(
                                        (v) => selectedIds.contains(v.verseID))
                                    .toList());
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15))),
                              child: Text("مشاركة"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedIds.clear();
                                  selectedIds.addAll(
                                      state.verses.map((v) => v.verseID));
                                });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15))),
                              child: Text("تحديد الكل"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedIds.clear();
                                });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(15))),
                              child: Text("إلغاء"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
