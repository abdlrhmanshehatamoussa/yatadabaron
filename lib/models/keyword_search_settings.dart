import 'package:yatadabaron/models/module.dart';

class KeywordSearchSettings {
  final String keyword;
  final bool basmala;
  final SearchMode mode;
  final int chapterID;
  final bool searchInWholeQuran;

  KeywordSearchSettings({
    required this.keyword,
    required this.basmala,
    required this.searchInWholeQuran,
    required this.mode,
    required this.chapterID,
  });

  KeywordSearchSettings copyWithKeyword(String newKeyword) {
    return KeywordSearchSettings(
      keyword: newKeyword,
      basmala: basmala,
      searchInWholeQuran: searchInWholeQuran,
      chapterID: chapterID,
      mode: mode,
    );
  }

  KeywordSearchSettings copyWithMode(SearchMode newMode) {
    return KeywordSearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: basmala,
      chapterID: chapterID,
      mode: newMode,
    );
  }

  KeywordSearchSettings copyWithBasmala(bool newBasmala) {
    return KeywordSearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: newBasmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  KeywordSearchSettings copyWithChapterId(int newChapterId) {
    return KeywordSearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: basmala,
      chapterID: newChapterId,
      mode: mode,
    );
  }

  static KeywordSearchSettings empty() {
    return new KeywordSearchSettings(
      keyword: "",
      basmala: false,
      searchInWholeQuran: true,
      mode: SearchMode.WITHIN,
      chapterID: 1,
    );
  }

  KeywordSearchSettings copyWithWholeQuran(bool wholeQuran) {
    return KeywordSearchSettings(
      keyword: keyword,
      searchInWholeQuran: wholeQuran,
      basmala: basmala,
      chapterID: chapterID,
      mode: mode,
    );
  }
}
