import 'package:flutter/material.dart';
import 'package:yatadabaron/app/config/page_router.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'controller.dart';
import 'package:yatadabaron/commons/base_view.dart';

import 'widgets/list.dart';

class BookmarksView extends BaseView<BookmarksController> {
  BookmarksView(BookmarksController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return CustomPageWrapper(
      pageTitle: Localization.BOOKMARKS,
      child: Center(
        child: FutureBuilder<List<Verse>>(
          future: controller.getBookmarkedVerses(),
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
                  view: PageRouter.instance.mushaf(
                    mushafSettings: MushafSettings.fromBookmark(
                      chapterId: loc.chapterId,
                      verseId: loc.verseId,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
