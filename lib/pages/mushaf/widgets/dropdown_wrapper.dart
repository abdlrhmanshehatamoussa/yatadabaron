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
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
          onPressed: onBack,
        ),
        VerticalDivider(),
        Expanded(
          child: GestureDetector(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${selectedChapter.chapterNameAR}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Usmani",
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 22,
                    ),
                  ),
                  TextSpan(
                    text: "   (${chapterSummary(selectedChapter)})",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  )
                ],
              ),
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
