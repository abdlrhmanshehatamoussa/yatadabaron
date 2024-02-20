import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/services/_i_local_repository.dart';

class BookmarksService implements IBookmarksService {
  BookmarksService({
    required this.repository,
  });

  final ILocalRepository<Bookmark> repository;

  @override
  Future<bool> addBookmark(Bookmark toAdd) async {
    //Check
    bool exists = await repository.any((loc) => loc.uniqueId == toAdd.uniqueId);
    if (exists) return false;

    //Add
    await repository.add(toAdd);
    return true;
  }

  @override
  Future<Bookmark?> getLastBookmark(MushafType mushafType) async {
    var bookmarks = await repository.getAll();
    bookmarks = bookmarks.where((b) => b.mushafType == mushafType).toList();
    if (bookmarks.length == 0) return null;
    return bookmarks.last;
  }

  @override
  Future<List<Bookmark>> getBookmarks(MushafType mushafType) async {
    var bookmarks = await repository.getAll();
    return bookmarks.where((b) => b.mushafType == mushafType).toList();
  }

  @override
  Future<void> removeBookmark(String uniqueId) async =>
      await repository.remove((b) => b.uniqueId == uniqueId);
}
