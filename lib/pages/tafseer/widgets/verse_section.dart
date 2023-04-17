import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';

class VerseSection extends StatelessWidget {
  final String verseTextTashkeel;
  final String chapterName;
  final int verseId;
  

  VerseSection({
    required this.verseTextTashkeel,
    required this.chapterName,
    required this.verseId,
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
        )
      ),
    );
  }
}
