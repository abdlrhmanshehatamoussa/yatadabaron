import 'package:yatadabaron/application/tafseer/interface.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/modules/persistence.module.dart';

class TafseerService implements ITafseerService {
  TafseerService(
    this._verseTafseerRepository,
    this._tafseerSourceRepository,
  );

  final IVerseTafseerRepository _verseTafseerRepository;
  final ITafseerSourceRepository _tafseerSourceRepository;

  @override
  Future<List<TafseerSource>> getTafseerSources() async {
    try {
      List<TafseerSource> local = await _tafseerSourceRepository.fetch();
      if (local.isEmpty) {
        await _tafseerSourceRepository.sync();
        local = await _tafseerSourceRepository.fetch();
        return local;
      }
      return local;
    } catch (e) {
      //TODO: log
      return [];
    }
  }

  @override
  Future<VerseTafseer> getTafseer(
    int tafseerId,
    int verseId,
    int chapterId,
  ) async {
    return await _verseTafseerRepository.fetch(
      chapterId: chapterId,
      verseId: verseId,
      tafseerId: tafseerId,
    );
  }

  @override
  Future<bool> syncTafseer(int tafseerId) async {
    return await _verseTafseerRepository.sync(tafseerId);
  }

  @override
  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    return await _verseTafseerRepository.getTafseerSizeMB(tafseerSourceID);
  }
}
