import 'package:arabic_numbers/arabic_numbers.dart';

class ArabicNumbersService {
  static ArabicNumbersService insance = ArabicNumbersService._();
  ArabicNumbersService._();

  ArabicNumbers _converter = ArabicNumbers();

  String convert(int? x, {bool reverse = true}) {
    String converted = _converter.convert(x);
    if (reverse == true) {
      String reversed = converted.split('').reversed.join();
      return reversed;
    } else {
      return converted;
    }
  }
}
