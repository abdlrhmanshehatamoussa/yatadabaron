import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_view.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'controller.dart';
import './widgets/dropdown.dart';
import './widgets/list.dart';

class MushafPage extends BaseView<MushafController> {
  MushafPage(MushafController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return CustomPageWrapper(
      pageTitle: Localization.DRAWER_QURAN,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<Chapter>(
                      stream: controller.selectedChapterStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          String? chName = snapshot.data!.chapterNameAR;
                          String chId = ArabicNumbersService.instance.convert(
                            snapshot.data!.chapterID,
                            reverse: false,
                          );
                          String title = "$chId - $chName";
                          return ListTile(
                            title: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Arial",
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data!.summary,
                              style: TextStyle(
                                fontFamily: "Arial",
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return LoadingWidget();
                      },
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: Icon(Icons.keyboard_arrow_down),
                    flex: 1,
                  )
                ],
              ),
              onTap: () async {
                List<Chapter> chapters =
                    await this.controller.getChaptersSimple;
                await ChaptersDropDown.show(
                  context: context,
                  chapters: chapters,
                  onChapterSelected: (Chapter chapter) async {
                    await this.controller.logChapterSelected(
                          chapter.chapterNameAR,
                          chapter.chapterID,
                        );
                    this.controller.reloadVerses(chapter.chapterID, null);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          Divider(
            height: 5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Expanded(
            child: VerseList(
              versesStream: this.controller.versesStream,
              onItemTap: (Verse result) {
                if (result.chapterId != null) {
                  navigatePush(
                    context: context,
                    view: PageRouter.instance.tafseer(
                      verseId: result.verseID,
                      chapterId: result.chapterId!,
                      onBookmarkSaved: () {
                        controller.reloadVerses(
                          result.chapterId,
                          result.verseID,
                        );
                      },
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
  }
}
