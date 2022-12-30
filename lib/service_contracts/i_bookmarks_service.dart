import 'package:yatadabaron/_modules/models.module.dart';

abstract class IBookmarksService {
  Future<void> removeBookmark(String id);

  Future<bool> addBookmark(int chapterId, int verseId);

  Future<List<Bookmark>> getBookmarks();

  Future<Bookmark?> getLastBookmark();
}
