import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/bookmarks/backend.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'widgets/list.dart';

class BookmarksView extends SimpleView {
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
              onBookmarkClick: (Bookmark loc) {
                navigateReplace(
                  context: context,
                  view: MushafPage(
                    mushafSettings: MushafSettings.fromBookmark(
                      chapterId: loc.chapterId,
                      verseId: loc.verseId,
                    ),
                  ),
                );
              },
              onBookmarkRemove: (Bookmark loc) async =>
                  await backend.removeBookmark(loc),
            );
          },
        ),
      ),
    );
  }
}
