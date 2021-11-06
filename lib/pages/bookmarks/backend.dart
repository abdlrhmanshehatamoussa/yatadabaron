import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class BookmarksBackend implements ISimpleBackend {
  BookmarksBackend({
    required this.versesService,
    required this.bookmarksService,
  }) {
    reloadBookmarks();
  }

  final IVersesService versesService;
  final IBookmarksService bookmarksService;

  StreamObject<List<Verse>> _versesStreamObj = StreamObject();
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
}
