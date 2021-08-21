import 'package:yatadabaron/modules/domain.module.dart';

abstract class ITafseerService {
  Future<List<TafseerSource>> getTafseerSources();
  Future<VerseTafseer> getTafseer(int tafseerId, int verseId, int chapterId);
  Future<bool> syncTafseer(int tafseerId);
  Future<int> getTafseerSizeMB(int tafseerSourceID);
}
