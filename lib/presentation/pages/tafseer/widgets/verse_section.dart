import 'package:flutter/material.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';

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
    String verseIdArabic = ArabicNumbersService.instance.convert(verseId);
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          verseTextTashkeel,
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        subtitle: Text(
          '$chapterName - [$verseIdArabic]',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Arabic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
