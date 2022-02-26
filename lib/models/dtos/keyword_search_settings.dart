import 'package:yatadabaron/_modules/models.module.dart';

class KeywordSearchSettings {
  final String keyword;
  final bool basmala;
  final SearchMode mode;
  final int? chapterID;

  KeywordSearchSettings({
    this.keyword = "",
    this.basmala = false,
    this.mode = SearchMode.WITHIN,
    this.chapterID,
  });

  bool get searchInWholeQuran => (chapterID == null);

  KeywordSearchSettings updateKeyword(String newKeyword) {
    return KeywordSearchSettings(
      keyword: newKeyword,
      basmala: basmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  KeywordSearchSettings updateMode(SearchMode newMode) {
    return KeywordSearchSettings(
      keyword: keyword,
      basmala: basmala,
      chapterID: chapterID,
      mode: newMode,
    );
  }

  KeywordSearchSettings updateBasmala(bool newBasmala) {
    return KeywordSearchSettings(
      keyword: keyword,
      basmala: newBasmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  KeywordSearchSettings updateChapterId(int? newChapterId) {
    return KeywordSearchSettings(
      keyword: keyword,
      basmala: basmala,
      chapterID: newChapterId,
      mode: mode,
    );
  }
}
