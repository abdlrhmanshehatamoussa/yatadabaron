import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:simply/simply.dart';
import '../_viewmodels/module.dart';

class BookmarksController {
  BookmarksController() {
    reloadBookmarks();
  }

  late IVersesService versesService = Simply.get<IVersesService>();
  late IBookmarksService bookmarksService = Simply.get<IBookmarksService>();
  final StreamObject<List<Bookmark>> _bookmarksStreamObj = StreamObject();
  Stream<List<Bookmark>> get bookmarksStream => _bookmarksStreamObj.stream;

  Future<void> reloadBookmarks() async {
    List<Bookmark> locations = await bookmarksService
        .getBookmarks(Simply.get<IMushafTypeService>().getMushafType());
    _bookmarksStreamObj.add(locations);
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    await bookmarksService.removeBookmark(bookmark.uniqueId);
    await reloadBookmarks();
  }

  void goMushafPage(Bookmark bookmark) {
    appNavigator.pushReplacementWidget(
      view: MushafPage(
        mushafSettings: MushafSettings.fromBookmark(
          chapterId: bookmark.chapterId,
          verseId: bookmark.verseId,
        ),
      ),
    );
  }
}
