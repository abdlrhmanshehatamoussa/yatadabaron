import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/global.dart';
import 'package:yatadabaron/pages/mushaf/controller.dart';
import 'package:yatadabaron/pages/mushaf/view_models/mushaf_state.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown_wrapper.dart';
import '../_viewmodels/module.dart';
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
  MushafController backend = MushafController();
  MushafPageState? state;
  bool showEmla2y = false;
  bool fullScreen = false;

  @override
  void initState() {
    backend.reloadVerses(widget.mushafSettings).then((value) {
      setState(() {
        state = value;
      });
    });
    WakelockPlus.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (state == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: fullScreen ? 0 : null,
        title: Padding(
          padding: EdgeInsets.all(15),
          child: MushafDropDownWrapper(
            onChapterSelected: (Chapter chapter) async {
              state = await backend.reloadVerses(
                MushafSettings.fromSelection(
                  chapterId: chapter.chapterID,
                  verseId: 1,
                ),
              );
              setState(() {
                selectedIds = [];
              });
            },
            chapters: state!.chapters,
            selectedChapter: state!.chapter,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                fullScreen = true;
                showEmla2y = false;
                selectedIds.clear();
              });
            },
            icon: Icon(
              Icons.fullscreen,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (showEmla2y) {
                  showEmla2y = false;
                } else {
                  showEmla2y = true;
                  showFeatureDialog();
                }
              });
            },
            icon: Icon(
              showEmla2y ? Icons.close : Icons.search,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Builder(
              builder: (_) {
                int? highlightedVerseId;
                IconData? icon;
                if (state!.mode == MushafMode.BOOKMARK ||
                    state!.mode == MushafMode.SEARCH) {
                  highlightedVerseId = state!.startFromVerse;
                  if (state!.mode == MushafMode.BOOKMARK) {
                    icon = Icons.bookmark_added_sharp;
                  } else {
                    icon = Icons.search_sharp;
                  }
                }
                return VerseList(
                  listKey: state != null ? Key(state!.chapter.chapterID.toString()) : UniqueKey(),
                  verses: state!.verses,
                  highlightedVerse: highlightedVerseId,
                  startFromVerse: state!.startFromVerse,
                  iconData: icon,
                  showEmla2y: showEmla2y,
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
                );
              },
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
                          "${selectedIds.length.toArabicNumber()}"
                          ")",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        TextButton(
                          onPressed: () async {
                            await backend.shareVerses(
                              state!.verses
                                  .where((v) => selectedIds.contains(v.verseID))
                                  .toList(),
                              state!.chapter.chapterNameAR,
                            );
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
                              selectedIds
                                  .addAll(state!.verses.map((v) => v.verseID));
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
      ),
      floatingActionButton: fullScreen
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  fullScreen = false;
                });
              },
              child: Icon(Icons.fullscreen_exit),
              mini: true,
            )
          : null,
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void showFeatureDialog() {
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
  }
}
