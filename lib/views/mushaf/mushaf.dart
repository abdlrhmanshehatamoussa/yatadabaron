import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../dtos/chapter-full-dto.dart';
import '../../helpers/localization.dart';
import '../../views/mushaf/chapters-dropdown.dart';
import 'list.dart';
import '../../views/shared-widgets/custom-page-wrapper.dart';
import '../../views/shared-widgets/loading-widget.dart';

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
}
