import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:simply/simply.dart';
import '../_viewmodels/module.dart';

class BookmarksBackend {
  BookmarksBackend() {
    reloadBookmarks();
  }

  late IVersesService versesService = Simply.get<IVersesService>();
  late IBookmarksService bookmarksService =
      Simply.get<IBookmarksService>();
  final StreamObject<List<Verse>> _versesStreamObj = StreamObject();
  Stream<List<Verse>> get bookmarkedVersesStream => _versesStreamObj.stream;

  Future<void> reloadBookmarks() async {
    List<Verse> results = [];
    List<Bookmark> locations = await bookmarksService.getBookmarks();
    for (var location in locations) {
      Verse v = await versesService.getSingleVerse(
          location.verseId, location.chapterId);
      results.add(v);
    }
    _versesStreamObj.add(results);
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    await bookmarksService.removeBookmark(bookmark.uniqueId);
    await reloadBookmarks();
  }

  void goMushafPage(Bookmark bookmark) {
    Simply.navReplace(
      view: MushafPage(
        mushafSettings: MushafSettings.fromBookmark(
          chapterId: bookmark.chapterId,
          verseId: bookmark.verseId,
        ),
      ),
    );
  }
}
