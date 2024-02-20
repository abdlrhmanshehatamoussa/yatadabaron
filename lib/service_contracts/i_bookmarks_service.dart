import 'package:yatadabaron/_modules/models.module.dart';

abstract class IBookmarksService {
  Future<void> removeBookmark(String id);

  Future<bool> addBookmark(Bookmark bookmark);

  Future<List<Bookmark>> getBookmarks(MushafType mushafType);

  Future<Bookmark?> getLastBookmark(MushafType mushafType);
}
