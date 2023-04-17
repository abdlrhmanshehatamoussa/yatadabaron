import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/_widgets/custom_search_toolbar.dart';

class VerseSection extends StatelessWidget {
  final String verseTextTashkeel;
  final String chapterName;
  final int verseId;
  final String verseTextEmla2y;
  

  VerseSection({
    required this.verseTextTashkeel,
    required this.chapterName,
    required this.verseId,
    required this.verseTextEmla2y,
  });

  @override
  Widget build(BuildContext context) {
    String verseIdArabic = Utils.convertToArabiNumber(verseId,reverse: false);
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          chapterName + "\n" + verseTextTashkeel + " " + verseIdArabic,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Usmani',
          ),
        ),
        subtitle: SelectableText(
          verseTextEmla2y,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'Arial',
          ),
          contextMenuBuilder: (context, editableTextState) => CustomSerachToolbar(editableTextState: editableTextState),
        ),
      ),
    );
  }
}
