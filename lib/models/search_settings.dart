import 'package:yatadabaron/models/module.dart';

class SearchSettings {
  final String keyword;
  final bool basmala;
  final SearchMode mode;
  final int chapterID;
  final bool searchInWholeQuran;

  SearchSettings({
    required this.keyword,
    required this.basmala,
    required this.searchInWholeQuran,
    required this.mode,
    required this.chapterID,
  });

  SearchSettings copyWithKeyword(String newKeyword) {
    return SearchSettings(
      keyword: newKeyword,
      basmala: basmala,
      searchInWholeQuran: searchInWholeQuran,
      chapterID: chapterID,
      mode: mode,
    );
  }

  SearchSettings copyWithMode(SearchMode newMode) {
    return SearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: basmala,
      chapterID: chapterID,
      mode: newMode,
    );
  }

  SearchSettings copyWithBasmala(bool newBasmala) {
    return SearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: newBasmala,
      chapterID: chapterID,
      mode: mode,
    );
  }

  SearchSettings copyWithChapterId(int newChapterId) {
    return SearchSettings(
      keyword: keyword,
      searchInWholeQuran: searchInWholeQuran,
      basmala: basmala,
      chapterID: newChapterId,
      mode: mode,
    );
  }

  static SearchSettings empty() {
    return new SearchSettings(
      keyword: "",
      basmala: false,
      searchInWholeQuran: true,
      mode: SearchMode.WITHIN,
      chapterID: 1,
    );
  }

  SearchSettings copyWithWholeQuran(bool wholeQuran) {
    return SearchSettings(
      keyword: keyword,
      searchInWholeQuran: wholeQuran,
      basmala: basmala,
      chapterID: chapterID,
      mode: mode,
    );
  }
}
