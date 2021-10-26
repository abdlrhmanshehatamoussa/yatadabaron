import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'list_item.dart';


class BookmarksList extends StatelessWidget {
  final List<Verse> verses;
  final Function(MushafLocation location) onBookmarkClick;

  const BookmarksList({
    Key? key,
    required this.verses,
    required this.onBookmarkClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (verses.length == 0) {
      return Text(Localization.EMPTY_SEARCH_RESULTS);
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
          onBookmarkClick: (MushafLocation loc) async =>
              await onBookmarkClick(loc),
        );
      },
    );
  }
}
