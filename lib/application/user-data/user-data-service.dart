import 'package:Yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class UserDataService implements IUserDataService {
  final UserDataRepository _repo;

  UserDataService(this._repo);
  
  Future<int?> getBookmarkChapter() async {
    return await _repo.getBookmarkChapter();
  }

  Future<int?> getBookmarkVerse() async {
    return await _repo.getBookmarkVerse();
  }

  Future<void> setBookmarkVerse(int verseId) async {
    await _repo.setBookmarkVerse(verseId);
  }

  Future<void> setBookmarkChapter(int chapterId) async {
    await _repo.setBookmarkChapter(chapterId);
  }
}
