import 'package:shared_preferences/shared_preferences.dart';
import 'interfaces/i_user_data_service.dart';

class UserDataService implements IUserDataService {
  UserDataService({
    required this.preferences,
  });

  final SharedPreferences preferences;

  static const String _BOOKMARK_CHAPTER_ID_KEY =
      "yatadabaron_bookmark_chapter_id";
  static const String _NIGHT_MODE_KEY = "yatadabaron_night_mode";
  static const String _BOOKMARK_VERSE_ID_KEY = "yatadabaron_bookmark_verse_id";

  Future<int?> getBookmarkChapter() async {
    return this._getInt(_BOOKMARK_CHAPTER_ID_KEY);
  }

  Future<int?> getBookmarkVerse() async {
    return this._getInt(_BOOKMARK_VERSE_ID_KEY);
  }

  Future<void> setBookmarkVerse(int verseId) async {
    await this.preferences.setInt(_BOOKMARK_VERSE_ID_KEY, verseId);
  }

  Future<void> setBookmarkChapter(int chapterId) async {
    await this.preferences.setInt(_BOOKMARK_CHAPTER_ID_KEY, chapterId);
  }

  @override
  Future<bool?> getNightMode() async {
    return this.preferences.getBool(_NIGHT_MODE_KEY);
  }

  @override
  Future<void> setNightMode(bool nightMode) async {
    await this.preferences.setBool(_NIGHT_MODE_KEY, nightMode);
  }

  int? _getInt(String k) {
    try {
      return this.preferences.getInt(k);
    } catch (e) {
      return null;
    }
  }
}
