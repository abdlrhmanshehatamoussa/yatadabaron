import 'package:yatadabaron/_modules/models.module.dart';

abstract class ITafseerService {
  Future<VerseTafseer> getTafseer(int tafseerId, int verseId, int chapterId);
  Future<bool> syncTafseer(int tafseerId);
  Future<int> getTafseerSizeMB(int tafseerSourceID);
}
