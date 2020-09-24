import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../dtos/chapter-simple-dto.dart';
import '../../helpers/localization.dart';
import '../../views/shared-widgets/loading-widget.dart';

class ChaptersDropDown extends StatelessWidget {
  final MushafBloc mushafBloc;

  const ChaptersDropDown(this.mushafBloc);

  @override
  Widget build(BuildContext context) {
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
          child: ListView.separated(
            separatorBuilder: (_,__)=>Divider(),
            itemCount: chapters.length,
            itemBuilder: (_, int i) {
              ChapterSimpleDTO chapter = chapters[i];
              return ListTile(
                title: Text(chapter.chapterNameAR),
                leading: Text("${chapter.chapterID}"),
                onTap: () {
                  mushafBloc.selectChapter(chapter.chapterID);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  static show(BuildContext context, MushafBloc bloc) {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text(
          Localization.SELECT_CHAPTER,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: EdgeInsets.all(5),
        children: <Widget>[
          ChaptersDropDown(bloc),
        ],
      ),
    );
  }
}
