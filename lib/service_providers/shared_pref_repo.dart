import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/services/module.dart';
import 'i_mapper.dart';

class SharedPrefRepository<T> implements ILocalRepository<T> {
  SharedPrefRepository({
    required this.preferences,
    required this.mapper,
  });

  final SharedPreferences preferences;
  final IMapper<T> mapper;
  final String myKey = T.toString();

  @override
  Future<void> add(T newItem) async {
    List<T> all = await getAll();
    all.add(newItem);
    await replace(all);
  }

  @override
  Future<List<T>> getAll() async {
    List<String>? jsonList = preferences.getStringList(T.toString());
    if (jsonList == null) return [];
    return jsonList.map((e) => mapper.fromJsonStr(e)).toList();
  }

  @override
  Future<void> merge(List<T> newItems) async {
    List<T> diff = [];
    List<T> local = await getAll();
    for (var newItem in newItems) {
      bool exists = local.any((T l) => mapper.isIdentical(newItem, l));
      if (!exists) diff.add(newItem);
    }
    await addBulk(diff);
  }

  @override
  Future<void> replace(List<T> newItems) async {
    List<String> toAdd = newItems.map((e) => mapper.toJsonStr(e)).toList();
    await preferences.setStringList(myKey, toAdd);
  }

  @override
  Future<void> addBulk(List<T> newItems) async {
    List<T> all = await getAll();
    all.addAll(newItems);
    await replace(all);
  }
}
