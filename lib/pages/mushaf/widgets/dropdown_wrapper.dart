import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown.dart';

class MushafDropDownWrapper extends StatelessWidget {
  final Function(Chapter chapter) onChapterSelected;
  final List<Chapter> chapters;
  final Chapter selectedChapter;

  const MushafDropDownWrapper({
    Key? key,
    required this.onChapterSelected,
    required this.chapters,
    required this.selectedChapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? chName = selectedChapter.chapterNameAR;
    String chId = ArabicNumbersService.instance.convert(
      selectedChapter.chapterID,
      reverse: false,
    );
    String title = "$chId - $chName";
    return Container(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Arial",
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  selectedChapter.summary,
                  style: TextStyle(
                    fontFamily: "Arial",
                    fontSize: 12,
                  ),
                ),
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
          await ChaptersDropDown.show(
            context: context,
            chapters: chapters,
            onChapterSelected: (Chapter chapter) async {
              await onChapterSelected(chapter);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
