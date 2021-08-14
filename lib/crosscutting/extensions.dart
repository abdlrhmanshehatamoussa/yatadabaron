import 'package:yatadabaron/modules/domain.module.dart';

import './localization.dart';

extension SearchModeExtended on SearchMode{
  String? get name{
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