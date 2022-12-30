import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class ITafseerService extends SimpleService {
  Future<VerseTafseer> getTafseer(int tafseerId, int verseId, int chapterId);
  Future<bool> syncTafseer(int tafseerId);
  Future<int> getTafseerSizeMB(int tafseerSourceID);
}
