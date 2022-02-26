import 'package:yatadabaron/models/bookmark.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/_module.dart';
import 'package:yatadabaron/simple/_module.dart';

abstract class IBookmarksService {
  Future<void> removeBookmark(String id);

  Future<bool> addBookmark(int chapterId, int verseId);

  Future<List<Bookmark>> getBookmarks();

  Future<Bookmark?> getLastBookmark();
}

class BookmarksService implements IBookmarksService, ISimpleService {
  BookmarksService({
    required this.preferences,
  });

  final SharedPreferences preferences;
  static const String _MUSHAF_LOCATIONS_KEY = "yatadabaron_mushaf_locations";

  @override
  Future<bool> addBookmark(int chapterId, int verseId) async {
    //Create
    Bookmark toAdd = Bookmark(
      chapterId: chapterId,
      verseId: verseId,
    );

    //Check
    List<Bookmark> locations = await getBookmarks();
    bool exists =
        locations.any((Bookmark loc) => loc.uniqueId == toAdd.uniqueId);
    if (exists) {
      return false;
    }

    //Add
    locations.add(toAdd);

    //Update
    _replaceBookmarksList(locations);
    return true;
  }

  @override
  Future<Bookmark?> getLastBookmark() async {
    List<Bookmark> locations = await getBookmarks();
    if (locations.length > 0) {
      return locations.last;
    }
  }

  @override
  Future<List<Bookmark>> getBookmarks() async {
    //Fetch
    List<String> mushafLocationsStr = _getList(_MUSHAF_LOCATIONS_KEY) ?? [];
    List<Bookmark> results = [];
    //Decode
    for (var mushafLocationStr in mushafLocationsStr) {
      Map<String, dynamic> jsonObj = jsonDecode(mushafLocationStr);
      Bookmark? loc = Bookmark.fromJson(jsonObj);
      if (loc != null) {
        results.add(loc);
      }
    }
    return results;
  }

  @override
  Future<void> removeBookmark(String uniqueId) async {
    //Fetch
    List<Bookmark> locations = await getBookmarks();

    int index = locations.indexWhere((Bookmark l) => l.uniqueId == uniqueId);
    if (index >= 0) {
      //Remove
      locations.removeAt(index);

      //Update
      await _replaceBookmarksList(locations);
    }
  }

  List<String>? _getList(String k) {
    try {
      return this.preferences.getStringList(k);
    } catch (e) {
      return null;
    }
  }

  Future _replaceBookmarksList(List<Bookmark> locations) async {
    //Encode
    List<String> encoded = [];
    for (var location in locations) {
      String json = jsonEncode(location.toJson());
      encoded.add(json);
    }

    //Save
    await this.preferences.setStringList(_MUSHAF_LOCATIONS_KEY, []);
    await this.preferences.setStringList(_MUSHAF_LOCATIONS_KEY, encoded);
  }
}
