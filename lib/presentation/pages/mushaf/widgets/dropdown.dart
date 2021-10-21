import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller.dart';

class ChaptersDropDown extends StatelessWidget {
  final BuildContext parentContext;
  const ChaptersDropDown(this.parentContext);

  @override
  Widget build(BuildContext context) {
    MushafController mushafBloc = Provider.of<MushafController>(this.parentContext);
    return FutureBuilder<List<Chapter>>(
      future: mushafBloc.getChaptersSimple,
      builder: (BuildContext context, AsyncSnapshot<List<Chapter>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<Chapter> chapters = snapshot.data!;
        return Container(
          height: 300,
          width: double.maxFinite,
          child: ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemCount: chapters.length,
            itemBuilder: (_, int i) {
              Chapter chapter = chapters[i];
              String idStr = ArabicNumbersService.instance
                  .convert(chapter.chapterID, reverse: false);
              return ListTile(
                title: Text(
                  chapter.chapterNameAR,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: Text(
                  "$idStr",
                  style: TextStyle(fontSize: 18, fontFamily: "Arial"),
                ),
                onTap: () async {
                  await mushafBloc.logChapterSelected(
                    chapter.chapterNameAR,
                    chapter.chapterID,
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
