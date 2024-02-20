import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/global.dart';

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
    TextStyle usmaniStyle = TextStyle(
      fontWeight: FontWeight.normal,
      fontFamily: Simply.get<IMushafTypeService>().getMushafType().fontName,
      fontSize: 18,
    );
    return ListTile(
      title: SingleChildScrollView(
        child: Text(
          verse.verseTextTashkel,
          style: TextStyle(
            fontSize: 20,
            overflow: TextOverflow.visible,  
          ),
          
        ),
        scrollDirection: Axis.horizontal,
      ),
      subtitle: SingleChildScrollView(
        child: Text(
          verse.chapterName!,
        ),
        scrollDirection: Axis.horizontal,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.close,
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
        verse.verseID.toArabicNumber(),
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
