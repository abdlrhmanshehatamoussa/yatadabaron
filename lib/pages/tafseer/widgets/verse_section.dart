import 'package:flutter/material.dart';
import 'package:yatadabaron/global.dart';

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
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
          title: Text(
        chapterName + "\n" + verseTextTashkeel + " " + verseId.toArabicNumber(),
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Usmani',
        ),
      )),
    );
  }
}
