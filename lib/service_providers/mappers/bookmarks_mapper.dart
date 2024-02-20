import 'dart:convert';

import 'package:yatadabaron/models/bookmark.dart';
import 'package:yatadabaron/service_providers/mappers/i_mapper.dart';

class BookmarksMapper implements IMapper<Bookmark> {
  @override
  Bookmark fromJsonStr(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return Bookmark.fromJson(json);
  }

  @override
  String toJsonStr(Bookmark obj) {
    return jsonEncode(obj.toJson());
  }
}
