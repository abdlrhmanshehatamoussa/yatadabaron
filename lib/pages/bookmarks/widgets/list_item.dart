import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/_module.dart';

class BookmarkListItem extends StatelessWidget {
  final Verse verse;
  final Function(Bookmark location) onBookmarkClick;
  final Function(Bookmark location) onBookmarkRemove;

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
    String verseIdArabic = Utils.convertToArabiNumber(verse.verseID);
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
          Bookmark(
            chapterId: verse.chapterId,
            verseId: verse.verseID,
          ),
        ),
      ),
      leading: Text(
        verseIdArabic,
        style: usmaniStyle.copyWith(fontSize: 32),
      ),
      onTap: () async => await onBookmarkClick(
        Bookmark(
          chapterId: verse.chapterId,
          verseId: verse.verseID,
        ),
      ),
    );
  }
}
