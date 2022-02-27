import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/models/bookmark.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/services/_i_local_repository.dart';
import 'package:yatadabaron/simple/_module.dart';

class BookmarksService implements IBookmarksService, ISimpleService {
  BookmarksService({
    required this.repository,
  });

  final ILocalRepository<Bookmark> repository;

  @override
  Future<bool> addBookmark(int chapterId, int verseId) async {
    //Prepare
    Bookmark toAdd = Bookmark(chapterId: chapterId, verseId: verseId);

    //Check
    bool exists = await repository.any((loc) => loc.uniqueId == toAdd.uniqueId);
    if (exists) return false;

    //Add
    await repository.add(toAdd);
    return true;
  }

  @override
  Future<Bookmark?> getLastBookmark() async => await repository.last();

  @override
  Future<List<Bookmark>> getBookmarks() async => await repository.getAll();

  @override
  Future<void> removeBookmark(String uniqueId) async =>
      await repository.remove((b) => b.uniqueId == uniqueId);
}
