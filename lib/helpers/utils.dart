import 'package:Yatadabaron/helpers/localization.dart';
import 'package:Yatadabaron/services/arabic-numbers-service.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class Utils {
  static List<String> arabicLetters() {
    return [
      "ء",
      "آ",
      "ا",
      "أ",
      "إ",
      "ب",
      "ت",
      "ة",
      "ث",
      "ج",
      "ح",
      "خ",
      "د",
      "ذ",
      "ر",
      "ز",
      "س",
      "ش",
      "ص",
      "ض",
      "ط",
      "ظ",
      "ع",
      "غ",
      "ف",
      "ق",
      "ك",
      "ل",
      "م",
      "ن",
      "ه",
      "و",
      "ؤ",
      "ي",
      "ئ",
      "ى"
    ];
  }

  static String replaceMultiple(
      String original, String replaceWhat, List<String> replcaeWith) {
    String result = original;
    replcaeWith.forEach((x) {
      result = result.replaceFirst(replaceWhat, x);
    });
    return result;
  }

  static TextStyle emptyListStyle() {
    return TextStyle(color: Colors.grey, fontStyle: FontStyle.italic);
  }

  static String findIgnoring(
      String input, String findWhat, String ignorePattern) {
    String pattern = "";
    for (int i = 0; i < findWhat.length; i++) {
      pattern += findWhat[i] + ignorePattern;
    }

    try {
      RegExp r = new RegExp(pattern);
      String value = r.firstMatch(input).group(0);
      return value;
    } catch (e) {
      return null;
    }
  }

  static Future<String> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return "$buildNumber | $version";
  }

  static List<String> splitVerseIntoTriplet(
      String verseText, String verseTextTashkel, String keyword) {
    String keywordTashkel = findIgnoring(
        verseTextTashkel, keyword, '[,ْ,ّ,َ,ٰ,ُ,ۛ,ً,ۖ,ٌ,ۗ,ٍ,ۚ,ۙ,ۘ,۩,ۜ]*');
    if (keywordTashkel == null) {
      return [verseTextTashkel, "", ""];
    }
    int start = verseTextTashkel.indexOf(keywordTashkel);
    int end = start + keywordTashkel.length;

    String before = verseTextTashkel.substring(0, start);
    String center = verseTextTashkel.substring(start, end);
    String after = verseTextTashkel.substring(end, verseTextTashkel.length);

    return [
      before,
      center,
      after,
    ];
  }

  static String numberTamyeez({
    String single,
    String plural,
    String mothana,
    int count,
    bool isMasculine,
  }) {
    String countAr =
        ArabicNumbersService.insance.convert(count, reverse: false);
    if (count == 1) {
      if (isMasculine) {
        return "$single ${Localization.ONE_MASC}";
      } else {
        return "$single ${Localization.ONE_FEM}";
      }
    }
    if (count == 2) {
      return mothana;
    }
    if (count <= 10) {
      return "$countAr $plural";
    } else {
      return "$countAr $single";
    }
  }

  static void showCustomDialog({
    BuildContext context,
    String title,
    String text,
  }) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: (text?.isNotEmpty ?? false) ? Text(text) : null,
        actions: <Widget>[
          FlatButton(
            child: Text(Localization.OK),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
