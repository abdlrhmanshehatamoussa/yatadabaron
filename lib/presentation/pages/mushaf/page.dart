import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/presentation/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './bloc.dart';
import './widgets/dropdown.dart';
import './widgets/list.dart';

class MushafPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MushafBloc mushafBloc = Provider.of<MushafBloc>(context);
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
                    child: StreamBuilder<ChapterFullDTO>(
                      stream: mushafBloc.selectedChapterStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          String? chName = snapshot.data!.chapterNameAR;
                          String chId = ArabicNumbersService.insance.convert(snapshot.data!.chapterId,reverse: false);
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
          Divider(),
          Expanded(
            child: VerseList(),
            flex: 1,
          )
        ],
      ),
    );
  }


  static void pushReplacement(BuildContext context,int? chapterId,int? verseId) {
    Navigator.of(context).pushReplacement(_getPageRoute(chapterId,verseId));
  }

  static MaterialPageRoute _getPageRoute(int? chapterId,int? verseId){
    return MaterialPageRoute(
      builder: (context) => Provider(
        child: MushafPage(),
        create: (contextt) => MushafBloc(chapterId, verseId),
      ),
    );
  }
}
