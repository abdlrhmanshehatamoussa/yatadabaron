import 'package:Yatadabaron/services/analytics-service.dart';
import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../dtos/chapter-simple-dto.dart';
import '../../helpers/localization.dart';
import '../../views/shared-widgets/loading-widget.dart';

class ChaptersDropDown extends StatelessWidget {
  final BuildContext parentContext;
  const ChaptersDropDown(this.parentContext);

  @override
  Widget build(BuildContext context) {
    MushafBloc mushafBloc = Provider.of<MushafBloc>(this.parentContext);
    return FutureBuilder<List<ChapterSimpleDTO>>(
      future: mushafBloc.getChaptersSimple,
      builder: (BuildContext context,
          AsyncSnapshot<List<ChapterSimpleDTO>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<ChapterSimpleDTO> chapters = snapshot.data!;
        return Container(
          height: 300,
          width: double.maxFinite,
          child: ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemCount: chapters.length,
            itemBuilder: (_, int i) {
              ChapterSimpleDTO chapter = chapters[i];
              String idStr = ArabicNumbersService.insance
                  .convert(chapter.chapterID, reverse: false);
              return ListTile(
                title: Text(
                  chapter.chapterNameAR!,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: Text(
                  "$idStr",
                  style: TextStyle(fontSize: 18, fontFamily: "Arial"),
                ),
                onTap: () {
                  AnalyticsService.instance.logOnTap(
                    "CHAPTER SELECTED",
                    payload:
                        "NAME=${chapter.chapterNameAR}|ID=${chapter.chapterID}",
                  );
                  mushafBloc.reloadVerses(chapter.chapterID, null);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  static show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text(
            Localization.SELECT_CHAPTER,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.all(5),
          children: <Widget>[
            ChaptersDropDown(context),
          ],
        );
      },
    );
  }
}
