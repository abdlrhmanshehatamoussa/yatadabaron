import '../enums/enums.dart';
import '../helpers/localization.dart';

extension SearchModeExtended on SearchMode{
  String get name{
    switch (this) {
      case SearchMode.END:
        return Localization.VERSE_END;
        break;
      case SearchMode.START:
        return Localization.VERSE_START;
        break;
      case SearchMode.WITHIN:
        return Localization.WITHIN_VERSE;
        break;
      case SearchMode.WORD:
        return Localization.WHOLE_WORD;
        break;
      default:
        return null;
        break;
    }
  }
}