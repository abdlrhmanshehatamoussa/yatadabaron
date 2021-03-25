import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreferences {
  static CustomSharedPreferences instance = CustomSharedPreferences._();
  SharedPreferences _preferences;
  static const String _BOOKMARK_CHAPTER_ID_KEY =
      "yatadabaron_bookmark_chapter_id";
  static const String _BOOKMARK_VERSE_ID_KEY = "yatadabaron_bookmark_verse_id";

  //Private Constructor
  CustomSharedPreferences._();

  //Initialize
  Future<void> initialize() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  //Helpers
  Future<String> _getString(String k) async {
    try {
      return this._preferences.getString(k);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> _getInt(String k) async {
    try {
      return this._preferences.getInt(k);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Get the saved bookmark chapter
  Future<int> getBookmarkChapter() async {
    return this._getInt(_BOOKMARK_CHAPTER_ID_KEY);
  }

  Future<bool> setBookmarkChapter(int v) async {
    return this._preferences.setInt(_BOOKMARK_CHAPTER_ID_KEY, v);
  }

  //Get the saved bookmark verse
  Future<int> getBookmarkVerse() async {
    return this._getInt(_BOOKMARK_VERSE_ID_KEY);
  }

  Future<bool> setBookmarkVerse(int v) async {
    return this._preferences.setInt(_BOOKMARK_VERSE_ID_KEY, v);
  }
}
