import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class ITafseerSourcesService
    extends SimpleService<ITafseerSourcesService> {
  Future<List<TafseerSource>> getTafseerSources();
}
