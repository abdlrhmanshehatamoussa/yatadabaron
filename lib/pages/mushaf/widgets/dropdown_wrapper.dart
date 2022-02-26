import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/mushaf/widgets/dropdown.dart';

class MushafDropDownWrapper extends StatelessWidget {
  final Function(Chapter chapter) onChapterSelected;
  final void Function() onBack;
  final List<Chapter> chapters;
  final Chapter selectedChapter;

  const MushafDropDownWrapper({
    Key? key,
    required this.onChapterSelected,
    required this.chapters,
    required this.selectedChapter,
    required this.onBack,
  }) : super(key: key);

  String chapterSummary(Chapter chapter) {
    String locationStr = chapter.location == ChapterLocation.MAKKI
        ? Localization.MECCA_LOCATION
        : Localization.MADINA_LOCATION;
    String versesCoun = Utils.numberTamyeez(
      count: chapter.verseCount,
      isMasculine: false,
      mothana: Localization.VERSE_MOTHANA,
      plural: Localization.VERSE_PLURAL,
      single: Localization.VERSE,
    );
    String chapterIdArabic = Utils.convertToArabiNumber(
      chapter.chapterID,
      reverse: false,
    );
    return "$chapterIdArabic | $locationStr | $versesCoun";
  }

  @override
  Widget build(BuildContext context) {
    String? chName = selectedChapter.chapterNameAR;
    String title = chName;
    return Row(
      children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
              size: 28,
            ),
          ),
          onTap: onBack,
        ),
        Expanded(
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
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: Text(
                      chapterSummary(selectedChapter),
                      style: TextStyle(
                        fontFamily: "Arial",
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
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
        ),
      ],
    );
  }
}
