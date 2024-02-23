import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/global.dart';

class StatisticsPayload {
  final String? chapterName;
  final List<LetterFrequency> results;

  StatisticsPayload(this.chapterName, this.results);

  String get summary {
    String result = Localization.STATISTICS_SUMMARY;

    int totalCount = 0;
    results.forEach((LetterFrequency lf) {
      totalCount += lf.frequency;
    });
    result = Utils.replaceMultiple(
        result, "#", [this.chapterName, totalCount.toArabicNumber()]);
    return result;
  }
}
