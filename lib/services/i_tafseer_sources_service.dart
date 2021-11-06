import 'package:yatadabaron/models/module.dart';

abstract class ITafseerSourcesService {
  Future<List<TafseerSource>> getTafseerSources();
}
