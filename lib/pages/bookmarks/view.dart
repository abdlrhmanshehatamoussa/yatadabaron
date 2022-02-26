import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/_module.dart';
import 'package:yatadabaron/pages/bookmarks/backend.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'widgets/list.dart';

class BookmarksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookmarksBackend backend = BookmarksBackend(context);
    return CustomPageWrapper(
      pageTitle: Localization.BOOKMARKS,
      child: Center(
        child: StreamBuilder<List<Verse>>(
          stream: backend.bookmarkedVersesStream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            List<Verse> verses = snapshot.data ?? [];
            return BookmarksList(
              verses: verses,
              onBookmarkClick: backend.goMushafPage,
              onBookmarkRemove: backend.removeBookmark,
            );
          },
        ),
      ),
    );
  }
}
