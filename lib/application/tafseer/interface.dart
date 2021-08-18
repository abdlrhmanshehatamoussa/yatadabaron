import 'package:yatadabaron/modules/domain.module.dart';

abstract class ITafseerService {
  Future<List<TafseerSource>> getTafseerSources();
  Future<VerseTafseer> getTafseer(int tafseerId, int verseId, int chapterId);
}
