import 'package:yatadabaron/_modules/models.module.dart';

abstract class ITafseerSourcesService {
  Future<List<TafseerSource>> getTafseerSources();
  Future<bool> syncTafseerSources();
}
