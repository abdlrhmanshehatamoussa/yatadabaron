import 'dart:convert';

import 'package:yatadabaron/models/bookmark.dart';
import 'package:yatadabaron/service_providers/mappers/i_mapper.dart';

class BookmarksMapper implements IMapper<Bookmark> {
  static const String _CHAPTER_ID = "chapter_id";
  static const String _VERSE_ID = "verse_id";

  @override
  Bookmark fromJsonStr(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return new Bookmark(
      chapterId: json[_CHAPTER_ID],
      verseId: json[_VERSE_ID],
    );
  }

  @override
  String toJsonStr(Bookmark obj) {
    Map<String, dynamic> json = new Map();
    json[_CHAPTER_ID] = obj.chapterId;
    json[_VERSE_ID] = obj.verseId;
    return jsonEncode(json);
  }
}
