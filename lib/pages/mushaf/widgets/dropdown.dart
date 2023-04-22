import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/commons/utils.dart';

class ChaptersDropDown extends StatelessWidget {
  final List<Chapter> chapters;
  final Function(Chapter chapter) onChapterSelected;

  ChaptersDropDown({
    required this.chapters,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.maxFinite,
      child: ListView.separated(
        separatorBuilder: (_, __) => Divider(),
        itemCount: chapters.length,
        itemBuilder: (_, int i) {
          Chapter chapter = chapters[i];
          String idStr = Utils.convertToArabiNumber(chapter.chapterID, reverse: false);
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
            onTap: () => this.onChapterSelected(chapter),
          );
        },
      ),
    );
  }

  static Future show({
    required BuildContext context,
    required List<Chapter> chapters,
    required Function(Chapter chapter) onChapterSelected,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text(
            Localization.SELECT_CHAPTER,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.all(5),
          children: <Widget>[
            ChaptersDropDown(
              chapters: chapters,
              onChapterSelected: onChapterSelected,
            ),
          ],
        );
      },
    );
  }
}
