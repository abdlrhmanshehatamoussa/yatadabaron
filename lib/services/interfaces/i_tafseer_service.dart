import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class ITafseerService extends SimpleService<ITafseerService> {
  Future<VerseTafseer> getTafseer(int tafseerId, int verseId, int chapterId);
  Future<bool> syncTafseer(int tafseerId);
  Future<int> getTafseerSizeMB(int tafseerSourceID);
}

