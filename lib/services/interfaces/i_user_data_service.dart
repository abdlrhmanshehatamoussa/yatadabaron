abstract class IUserDataService {
  Future<int?> getBookmarkChapter();

  Future<int?> getBookmarkVerse();

  Future<void> setBookmarkVerse(int verseId);

  Future<void> setBookmarkChapter(int chapterId);

  Future<bool?> getNightMode();

  Future<void> setNightMode(bool nightMode);
}
