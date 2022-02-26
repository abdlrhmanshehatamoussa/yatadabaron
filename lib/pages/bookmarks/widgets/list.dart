import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/_module.dart';
import 'list_item.dart';

class BookmarksList extends StatelessWidget {
  final List<Verse> verses;
  final Function(Bookmark bookmark) onBookmarkClick;
  final Function(Bookmark bookmark) onBookmarkRemove;

  const BookmarksList({
    Key? key,
    required this.verses,
    required this.onBookmarkClick,
    required this.onBookmarkRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (verses.length == 0) {
      return Text(Localization.EMPTY_BOOKMARKS);
    }
    return ListView.separated(
      separatorBuilder: (_, __) {
        return Divider(
          color: Colors.grey,
          height: 10,
        );
      },
      itemCount: verses.length,
      itemBuilder: (_, int index) {
        Verse verse = verses[index];
        return BookmarkListItem(
          verse: verse,
          onBookmarkRemove: (Bookmark loc) async =>
              await onBookmarkRemove(loc),
          onBookmarkClick: (Bookmark loc) async =>
              await onBookmarkClick(loc),
        );
      },
    );
  }
}
