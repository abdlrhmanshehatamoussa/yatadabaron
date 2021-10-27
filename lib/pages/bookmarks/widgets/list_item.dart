import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class BookmarkListItem extends StatelessWidget {
  final Verse verse;
  final Function(MushafLocation location) onBookmarkClick;
  final Function(MushafLocation location) onBookmarkRemove;

  const BookmarkListItem({
    Key? key,
    required this.verse,
    required this.onBookmarkClick,
    required this.onBookmarkRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "${verse.chapterName}";
    String subtitle = "${verse.verseTextTashkel}";
    String verseIdArabic = ArabicNumbersService.instance.convert(verse.verseID);
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
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever,
          size: 30,
        ),
        onPressed: () async => await onBookmarkRemove(
          MushafLocation(
            chapterId: verse.chapterId!,
            verseId: verse.verseID,
          ),
        ),
      ),
      leading: Text(
        verseIdArabic,
        style: usmaniStyle.copyWith(fontSize: 32),
      ),
      onTap: () async => await onBookmarkClick(
        MushafLocation(
          chapterId: verse.chapterId!,
          verseId: verse.verseID,
        ),
      ),
    );
  }
}
