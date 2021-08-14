import 'package:yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class UserDataService implements IUserDataService {
  final UserDataRepository _repo;

  UserDataService(this._repo);
  
  Future<int?> getBookmarkChapter() async {
    return _repo.getBookmarkChapter();
  }

  Future<int?> getBookmarkVerse() async {
    return _repo.getBookmarkVerse();
  }

  Future<void> setBookmarkVerse(int verseId) async {
    await _repo.setBookmarkVerse(verseId);
  }

  Future<void> setBookmarkChapter(int chapterId) async {
    await _repo.setBookmarkChapter(chapterId);
  }

  @override
  Future<bool?> getNightMode() async {
    return _repo.getNightMode();
  }

  @override
  Future<void> setNightMode(bool nightMode) async {
    await _repo.setNightMode(nightMode);
  }
}
