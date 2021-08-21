import 'package:shared_preferences/shared_preferences.dart';

class UserDataRepository {
  final SharedPreferences _preferences;
  static const String _BOOKMARK_CHAPTER_ID_KEY =
      "yatadabaron_bookmark_chapter_id";
  static const String _NIGHT_MODE_KEY = "yatadabaron_night_mode";
  static const String _BOOKMARK_VERSE_ID_KEY = "yatadabaron_bookmark_verse_id";

  UserDataRepository(this._preferences);

  //Get the saved bookmark chapter
  int? getBookmarkChapter() {
    return this._getInt(_BOOKMARK_CHAPTER_ID_KEY);
  }

  Future<bool> setBookmarkChapter(int v) async {
    return await this._preferences.setInt(_BOOKMARK_CHAPTER_ID_KEY, v);
  }

  //Get the saved bookmark verse
  int? getBookmarkVerse() {
    return this._getInt(_BOOKMARK_VERSE_ID_KEY);
  }

  Future<bool> setBookmarkVerse(int v) async {
    return await this._preferences.setInt(_BOOKMARK_VERSE_ID_KEY, v);
  }

  //Night Mode
  bool? getNightMode() {
    return this._preferences.getBool(_NIGHT_MODE_KEY);
  }

  Future<void> setNightMode(bool mode) async {
    await this._preferences.setBool(_NIGHT_MODE_KEY, mode);
  }

  int? _getInt(String k) {
    try {
      return this._preferences.getInt(k);
    } catch (e) {
      return null;
    }
  }
}
