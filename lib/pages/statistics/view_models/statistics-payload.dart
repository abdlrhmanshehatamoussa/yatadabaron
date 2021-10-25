import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/viewmodels/module.dart';

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
    String totalCountAr =
        ArabicNumbersService.instance.convert(totalCount, reverse: false);
    result = Utils.replaceMultiple(
        result, "#", [this.chapterName, basmalaState, totalCountAr]);
    return result;
  }
}
