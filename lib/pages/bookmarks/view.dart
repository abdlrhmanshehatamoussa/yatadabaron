import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/bookmarks/controller.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import 'widgets/list.dart';

class BookmarksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookmarksController backend = BookmarksController();
    return CustomPageWrapper(
      pageTitle: Localization.BOOKMARKS,
      child: Center(
        child: StreamBuilder<List<Bookmark>>(
          stream: backend.bookmarksStream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            List<Bookmark> bookmarks = snapshot.data ?? [];
            return BookmarksList(
              bookmarks: bookmarks,
              onBookmarkClick: backend.goMushafPage,
              onBookmarkRemove: backend.removeBookmark,
            );
          },
        ),
      ),
    );
  }
}
