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
    try{
      List<TafseerSource> local = await _tafseerSourceRepository.getLocal();
      if (local.isEmpty) {
        await _tafseerSourceRepository.sync();
        local = await _tafseerSourceRepository.getLocal();
        return local;
      }
      return local;
    }catch(e){
      print(e.toString());
      return [];
    }
  }

  @override
  Future<VerseTafseer> getTafseer(
    int tafseerId,
    int verseId,
    int chapterId,
  ) async {
    return await _verseTafseerRepository.getTafseer(
      chapterId: chapterId,
      verseId: verseId,
      tafseerId: tafseerId,
    );
  }
}
