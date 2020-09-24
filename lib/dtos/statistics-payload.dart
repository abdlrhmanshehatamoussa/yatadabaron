import '../dtos/letter-frequency.dart';
import '../helpers/localization.dart';
import '../helpers/utils.dart';

class StatisticsPayload{
  final String chapterName;
  final bool basmala;
  final List<LetterFrequency> results;

  StatisticsPayload(this.chapterName,this.basmala,this.results);

  String get summary{
    String result = Localization.STATISTICS_SUMMARY;
    String basmalaState = basmala ? Localization.INCLUDING : Localization.IGNORING;
    int totalCount = 0;
    results.forEach((LetterFrequency lf){
      totalCount += lf.frequency;
    });
    result = Utils.replaceMultiple(result, "#", [this.chapterName,basmalaState,totalCount.toString()]);
    return result;
  }
}