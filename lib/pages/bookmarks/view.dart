import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/bookmarks/controller.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'widgets/list.dart';

class BookmarksView extends SimpleView<BookmarksController> {
  @override
  Widget build(BuildContext context) {
    BookmarksController controller = getController(context);
    return CustomPageWrapper(
      pageTitle: Localization.BOOKMARKS,
      child: Center(
        child: StreamBuilder<List<Verse>>(
          stream: controller.bookmarkedVersesStream,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            List<Verse> verses = snapshot.data ?? [];
            return BookmarksList(
              verses: verses,
              onBookmarkClick: (MushafLocation loc) {
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
              onBookmarkRemove: (MushafLocation loc) async =>
                  await controller.removeBookmark(loc),
            );
          },
        ),
      ),
    );
  }

  @override
  BookmarksController provideController(
      ISimpleServiceProvider serviceProvider) {
    return BookmarksController(
      versesService: serviceProvider.getService<IVersesService>(),
      userDataService: serviceProvider.getService<IUserDataService>(),
    );
  }
}
