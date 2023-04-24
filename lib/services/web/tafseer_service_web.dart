import 'dart:async';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class TafseerServiceWeb extends ITafseerService {
  final String tafseerURL;
  final Map<String, String> cache = {};
  TafseerServiceWeb({required this.tafseerURL});

  @override
  Future<VerseTafseer> getTafseer(
    int tafseerId,
    int verseId,
    int chapterId,
  ) async {
    var key = "$tafseerId.$chapterId.$verseId";
    return VerseTafseer(
      tafseerText: "N/A",
      tafseerSourceID: tafseerId,
      verseId: verseId,
    );
  }

  @override
  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    return 0;
  }

  @override
  Future<bool> syncTafseer(int tafseerId) async {
    return true;
  }
}
