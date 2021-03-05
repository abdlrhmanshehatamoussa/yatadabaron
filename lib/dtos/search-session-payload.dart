import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:share/share.dart';

import '../dtos/search-settings.dart';
import '../dtos/verse-dto-collection.dart';
import '../dtos/verse-dto.dart';
import '../helpers/localization.dart';
import '../helpers/utils.dart';

class SearchSessionPayload {
  final String chapterName;
  final List<VerseDTO> results;
  final SearchSettings settings;
  SearchSessionPayload(this.settings, this.chapterName, this.results);

  String get summary {
    if (settings.chapterID == 0) {
      String original = Localization.SEARCH_SUMMARY_WHOLE_QURAN;
      int chaptersCount = results.map((v) => v.chapterName).toSet().length;
      original = Utils.replaceMultiple(
        original,
        "#",
        [
          ArabicNumbersService.insance.convert(results.length,reverse: false),
          settings.keyword,
          ArabicNumbersService.insance.convert(chaptersCount,reverse: false),
        ],
      );
      return original;
    } else {
      String original = Localization.SEARCH_SUMMARY;
      original = Utils.replaceMultiple(
        original,
        "#",
        [
          ArabicNumbersService.insance.convert(results.length,reverse: false),
          settings.keyword,
          chapterName,
        ],
      );
      return original;
    }
  }

  List<VerseCollection> get verseCollections {
    List<VerseCollection> collections = [];
    List<String> chapterNames =
        results.map((v) => v.chapterName).toSet().toList();
    chapterNames.forEach((String chapter) {
      List<VerseDTO> verses =
          results.where((v) => v.chapterName == chapter).toList();
      collections.add(VerseCollection(verses, chapter));
    });
    collections.sort((a, b) => a.verses.length.compareTo(b.verses.length));
    return collections.reversed.toList();
  }

  void copyAll(){
    String resultsStr = "$summary\n\n";
    results.forEach((VerseDTO verseDTO) {
      resultsStr += "${verseDTO.chapterName}\n${verseDTO.verseTextTashkel} {${verseDTO.verseID}}\n\n";
    });
    Share.share(resultsStr);
  }

  void copyVerse(VerseDTO verseDTO){
    String toCopy = "${verseDTO.chapterName}\n${verseDTO.verseTextTashkel} {${verseDTO.verseID}}";
    Share.share(toCopy);
  }
}
