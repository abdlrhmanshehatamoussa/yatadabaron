import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:share/share.dart';
import '../dtos/search-settings.dart';
import '../dtos/verse-dto-collection.dart';
import '../dtos/verse-dto.dart';
import '../enums/enums.dart';

class SearchSessionPayload {
  final String? chapterName;
  final List<VerseDTO> results;
  final SearchSettings settings;
  SearchSessionPayload(this.settings, this.chapterName, this.results);

  String get summary {
    int count = 0;
    for (var result in results) {
      List<String> words = result.verseText!.split(" ");
      for (var word in words) {
        bool found = false;
        switch (settings.mode) {
          case SearchMode.WORD:
            found = word == this.settings.keyword;
            break;
          case SearchMode.START:
          case SearchMode.END:
          case SearchMode.WITHIN:
            found = word.contains(this.settings.keyword);
            break;
          default:
            break;
        }
        if (found) {
          count++;
        }
      }
    }
    if (settings.chapterID == 0) {
      String original = Localization.SEARCH_SUMMARY_WHOLE_QURAN;
      int chaptersCount = results.map((v) => v.chapterName).toSet().length;
      original = Utils.replaceMultiple(
        original,
        "#",
        [
          ArabicNumbersService.insance.convert(count, reverse: false),
          settings.keyword,
          ArabicNumbersService.insance.convert(chaptersCount, reverse: false),
        ],
      );
      return original;
    } else {
      String original = Localization.SEARCH_SUMMARY;
      original = Utils.replaceMultiple(
        original,
        "#",
        [
          ArabicNumbersService.insance.convert(count, reverse: false),
          settings.keyword,
          chapterName,
        ],
      );
      return original;
    }
  }

  List<VerseCollection> get verseCollections {
    List<VerseCollection> collections = [];
    List<String?> chapterNames =
        results.map((v) => v.chapterName).toSet().toList();
    chapterNames.forEach((String? chapter) {
      List<VerseDTO> verses =
          results.where((v) => v.chapterName == chapter).toList();
      collections.add(VerseCollection(verses, chapter));
    });
    collections.sort((a, b) => a.verses.length.compareTo(b.verses.length));
    return collections.reversed.toList();
  }

  void copyAll() {
    String resultsStr = "$summary\n\n";
    results.forEach((VerseDTO verseDTO) {
      resultsStr +=
          "${verseDTO.chapterName}\n${verseDTO.verseTextTashkel} {${verseDTO.verseID}}\n\n";
    });
    Share.share(resultsStr);
  }

  void copyVerse(VerseDTO verseDTO) {
    ServiceManager.instance.analyticsService.logOnTap("SHARE VERSE");
    String toCopy =
        "${verseDTO.chapterName}\n${verseDTO.verseTextTashkel} {${verseDTO.verseID}}";
    Share.share(toCopy);
  }
}
