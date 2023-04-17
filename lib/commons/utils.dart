import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import './localization.dart';
import 'package:flutter/material.dart';

class Utils {
  static String convertToArabiNumber(dynamic x, {bool reverse = true}) {
    String converted = ArabicNumbers().convert(x);
    if (reverse == true) {
      String reversed = converted.split('').reversed.join();
      return reversed;
    } else {
      return converted;
    }
  }

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
      String original, String replaceWhat, List<String?> replcaeWith) {
    String result = original;
    replcaeWith.forEach((x) {
      result = result.replaceFirst(replaceWhat, x!);
    });
    return result;
  }

  static TextStyle emptyListStyle() {
    return TextStyle(fontStyle: FontStyle.italic);
  }

  static String? findIgnoring(
      String input, String findWhat, String ignorePattern) {
    String pattern = "";
    for (int i = 0; i < findWhat.length; i++) {
      pattern += findWhat[i] + ignorePattern;
    }

    try {
      RegExp r = new RegExp(pattern);
      String? value = r.firstMatch(input)!.group(0);
      return value;
    } catch (e) {
      return null;
    }
  }

  static List<String> splitVerseIntoTriplet(
      String verseText, String verseTextTashkel, String keyword) {
    String? keywordTashkel = findIgnoring(
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
    required String single,
    required String plural,
    required String mothana,
    required int count,
    required bool isMasculine,
  }) {
    String countAr = Utils.convertToArabiNumber(count, reverse: false);
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

  static Future<void> showCustomDialog({
    required BuildContext context,
    String? title,
    String? text,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title!),
          content: (text?.isNotEmpty ?? false) ? Text(text!) : null,
          actions: <Widget>[
            TextButton(
              child: Text(Localization.OK),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  static Future<void> showFeatureUpdateDialog({
    required BuildContext context,
    required String updateId,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    var service = Simply.get<IMutedMessagesService>();
    if (await service.isMuted(updateId)) {
      return;
    }
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Wrap(
          children: [
            Text(body),
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.scaleDown,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  )
                : Container(),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "إخفاء",
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () async {
              await service.mute(updateId);
              Navigator.of(context).pop();
            },
            child: Text(
              "عدم الإظهار مرة آخرى",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  static Future<void> showPleaseWaitDialog({
    required BuildContext context,
    required String title,
    required String text,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                CircularProgressIndicator(),
                Expanded(
                  child: Center(
                    child: Text(text),
                  ),
                )
              ],
            ),
          ),
          actions: [],
        );
      },
    );
  }

  static List<int> findIndicesOfChar(String textTashkel, String char) {
    List<int> result = [];
    if (textTashkel.isNotEmpty) {
      for (var i = 0; i < textTashkel.length; i++) {
        if (textTashkel[i] == char) {
          result.add(i);
        }
      }
    }
    return result;
  }

  static String substring({
    required String text,
    required int startFrom,
    int? count,
    List? countIf,
  }) {
    String sub = text.substring(startFrom);
    String result = "";
    int c = 0;
    for (var i = 0; i < sub.length; i++) {
      if (c < count!) {
        String subi = sub[i];
        result = result + subi;
        if (countIf!.contains(subi)) {
          c++;
        }
      }
    }
    return result;
  }

  static String reduce({
    required String text,
    List<String>? countIf,
  }) {
    String reduced = "";
    for (var i = 0; i < text.length; i++) {
      String crnt = text[i];
      if (countIf!.contains(crnt)) {
        reduced += crnt;
      }
    }
    return reduced;
  }

  static List<List<int>> findAllSpans(String needle, String haystack) {
    List<List<int>> results = [];
    int index = haystack.indexOf(needle);
    while (index >= 0) {
      results.add([index, index + needle.length - 1]);
      index = haystack.indexOf(needle, index + needle.length);
    }
    return results;
  }
}
