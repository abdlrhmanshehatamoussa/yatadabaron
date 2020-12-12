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
        List<ChapterSimpleDTO> chapters = snapshot.data;
        return Container(
          height: 300,
          width: double.maxFinite,
          child: ListView.separated(
            separatorBuilder: (_,__)=>Divider(),
            itemCount: chapters.length,
            itemBuilder: (_, int i) {
              ChapterSimpleDTO chapter = chapters[i];
              return ListTile(
                title: Text(chapter.chapterNameAR),
                leading: Text("${chapter.chapterID}"),
                onTap: () {
                  mushafBloc.selectChapter(chapter.chapterID,1);
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
      child: SimpleDialog(
        title: Text(
          Localization.SELECT_CHAPTER,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: EdgeInsets.all(5),
        children: <Widget>[
          ChaptersDropDown(context),
        ],
      ),
    );
  }
}
