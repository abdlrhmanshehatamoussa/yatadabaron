import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/module.dart';
import '_shared_pref_repo.dart';
import '../_mappers/tafseer_source_mapper.dart';

class TafseerSourcesRepository extends SharedPrefRepository<TafseerSource> {
  TafseerSourcesRepository({required SharedPreferences pref})
      : super(mapper: new TafseerSourceMapper(), preferences: pref);
}
