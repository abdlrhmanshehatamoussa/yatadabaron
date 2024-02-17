import 'package:yatadabaron/commons/localization.dart';

enum SearchState { INITIAL, IN_PROGRESS, DONE, INVALID_SETTINGS }

enum SearchMode { START, END, WORD, WITHIN }

enum ChapterLocation { MAKKI, MADANI }

enum MushafMode { BOOKMARK, SEARCH, SELECTION }

enum MushafType { HAFS, WARSH, QALOON }

extension MushafTypeExtended on MushafType {
  String get fontName {
    switch (this) {
      case MushafType.HAFS:
        return "Usmani";
      case MushafType.WARSH:
        return "Warsh";
      default:
        return "Usmani";
    }
  }
}

extension SearchModeExtended on SearchMode {
  String? get name {
    switch (this) {
      case SearchMode.END:
        return Localization.VERSE_END;
      case SearchMode.START:
        return Localization.VERSE_START;
      case SearchMode.WITHIN:
        return Localization.WITHIN_VERSE;
      case SearchMode.WORD:
        return Localization.WHOLE_WORD;
      default:
        return null;
    }
  }
}
