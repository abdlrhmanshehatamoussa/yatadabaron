import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class BookmarkListItem extends StatelessWidget {
  final Verse verse;
  final Function(MushafLocation location) onBookmarkClick;

  const BookmarkListItem({
    Key? key,
    required this.verse,
    required this.onBookmarkClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "${verse.chapterName}";
    String subtitle = "${verse.verseTextTashkel}";
    String trailingStr = ArabicNumbersService.instance.convert(verse.verseID);
    TextStyle usmaniStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: "Usmani",
      fontSize: 18,
    );
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: SingleChildScrollView(
        child: Text(
          subtitle,
          style: usmaniStyle,
        ),
        scrollDirection: Axis.horizontal,
      ),
      leading: Text(
        trailingStr,
        style: usmaniStyle.copyWith(fontSize: 32),
      ),
      onTap: () => onBookmarkClick(
        MushafLocation(
          chapterId: verse.chapterId!,
          verseId: verse.verseID,
        ),
      ),
    );
  }
}
