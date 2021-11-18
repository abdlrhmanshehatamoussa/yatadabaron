import 'package:yatadabaron/models/module.dart';

class SearchSettings {
  final String keyword;
  final bool basmala;
  final SearchMode mode;
  final int chapterID;

  SearchSettings({
    required this.keyword,
    required this.basmala,
    required this.mode,
    required this.chapterID,
  });

  bool get searchInWholeQuran => chapterID == 0;

  SearchSettings copyWithKeyword(String newKeyword) {
    return SearchSettings(
      keyword: newKeyword,
      basmala: basmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  SearchSettings copyWithMode(SearchMode newMode) {
    return SearchSettings(
      keyword: keyword,
      basmala: basmala,
      chapterID: chapterID,
      mode: newMode,
    );
  }

  SearchSettings copyWithBasmala(bool newBasmala) {
    return SearchSettings(
      keyword: keyword,
      basmala: newBasmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  SearchSettings copyWithChapterId(int newChapterId) {
    return SearchSettings(
      keyword: keyword,
      basmala: basmala,
      chapterID: newChapterId,
      mode: mode,
    );
  }

  static SearchSettings empty() {
    return new SearchSettings(
      keyword: "",
      basmala: false,
      mode: SearchMode.WITHIN,
      chapterID: 0,
    );
  }
}
