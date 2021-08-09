import 'package:Yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class UserDataService implements IUserDataService {
  Future<int?> getBookmarkChapter() async {
    await UserDataRepository.instance.getBookmarkChapter();
  }

  Future<int?> getBookmarkVerse() async {
    await UserDataRepository.instance.getBookmarkVerse();
  }

  Future<void> setBookmarkVerse(int verseId) async {
    await UserDataRepository.instance.setBookmarkVerse(verseId);
  }

  Future<void> setBookmarkChapter(int chapterId) async {
    await UserDataRepository.instance.setBookmarkChapter(chapterId);
  }
}
