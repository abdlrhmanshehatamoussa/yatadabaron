import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class ITafseerSourcesService extends SimpleService {
  Future<List<TafseerSource>> getTafseerSources();
}
