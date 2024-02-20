import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'list_item.dart';

class BookmarksList extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final Function(Bookmark bookmark) onBookmarkClick;
  final Function(Bookmark bookmark) onBookmarkRemove;

  const BookmarksList({
    Key? key,
    required this.bookmarks,
    required this.onBookmarkClick,
    required this.onBookmarkRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bookmarks.length == 0) {
      return Text(Localization.EMPTY_BOOKMARKS);
    }
    return ListView.separated(
      separatorBuilder: (_, __) {
        return Divider(
          color: Colors.grey,
          height: 10,
        );
      },
      itemCount: bookmarks.length,
      itemBuilder: (_, int index) {
        Bookmark bookmark = bookmarks[index];
        return BookmarkListItem(
          bookmark: bookmark,
          onRemove: () async => await onBookmarkRemove(bookmark),
          onClick: () async => await onBookmarkClick(bookmark),
        );
      },
    );
  }
}
