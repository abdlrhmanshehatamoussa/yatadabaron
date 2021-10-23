import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/mvc/base_view.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'controller.dart';
import './widgets/dropdown.dart';
import './widgets/list.dart';

class MushafPage extends BaseView<MushafController> {
  MushafPage(MushafController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ControllerManager manager = Provider.of<ControllerManager>(context);
    return CustomPageWrapper(
      drawer: CustomDrawer(manager.drawerController()),
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
              onTap: () {
                ChaptersDropDown.show(context);
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
                if (result.verseID != null && result.chapterId != null) {
                  navigatePush(
                    context: context,
                    view: TafseerPage(
                      manager.tafseerPageController(
                        verseId: result.verseID!,
                        chapterId: result.chapterId!,
                        onBookmarkSaved: () {
                          this.controller.reloadVerses(
                                result.chapterId,
                                result.verseID,
                              );
                        },
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
  }
}
