import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/global.dart';

class StatisticsPayload {
  final String? chapterName;
  final bool basmala;
  final List<LetterFrequency> results;

  StatisticsPayload(this.chapterName, this.basmala, this.results);

  String get summary {
    String result = Localization.STATISTICS_SUMMARY;
    String basmalaState =
        basmala ? Localization.INCLUDING : Localization.IGNORING;
    int totalCount = 0;
    results.forEach((LetterFrequency lf) {
      totalCount += lf.frequency;
    });
    result = Utils.replaceMultiple(result, "#",
        [this.chapterName, basmalaState, totalCount.toArabicNumber()]);
    return result;
  }
}
