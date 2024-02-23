import 'package:yatadabaron/_modules/models.module.dart';

class KeywordSearchSettings {
  final String keyword;
  final SearchMode mode;
  final int? chapterID;

  KeywordSearchSettings({
    this.keyword = "",
    this.mode = SearchMode.WITHIN,
    this.chapterID,
  });

  bool get searchInWholeQuran => (chapterID == null);

  KeywordSearchSettings updateKeyword(String newKeyword) {
    return KeywordSearchSettings(
      keyword: newKeyword,
      chapterID: chapterID,
      mode: mode,
    );
  }

  KeywordSearchSettings updateMode(SearchMode newMode) {
    return KeywordSearchSettings(
      keyword: keyword,
      chapterID: chapterID,
      mode: newMode,
    );
  }

  KeywordSearchSettings updateChapterId(int? newChapterId) {
    return KeywordSearchSettings(
      keyword: keyword,
      chapterID: newChapterId,
      mode: mode,
    );
  }
}
