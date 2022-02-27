import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/_modules/services.module.dart';
import '../mappers/i_mapper.dart';

class SharedPrefRepository<T> implements ILocalRepository<T> {
  SharedPrefRepository({
    required this.preferences,
    required this.mapper,
  });

  final SharedPreferences preferences;
  final IMapper<T> mapper;
  final String myKey = "yatadabaron_${T.toString()}";

  @override
  Future<void> add(T newItem) async {
    List<T> all = await getAll();
    all.add(newItem);
    await replace(all);
  }

  @override
  Future<List<T>> getAll() async {
    List<String>? jsonList = preferences.getStringList(myKey);
    if (jsonList == null) return [];
    return jsonList.map((e) => mapper.fromJsonStr(e)).toList();
  }

  @override
  Future<void> merge(
    List<T> newItems,
    bool Function(T, T) compareFunction,
  ) async {
    List<T> diff = [];
    List<T> local = await getAll();
    for (var newItem in newItems) {
      bool exists = local.any((T l) => compareFunction(newItem, l));
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

  @override
  Future<bool> any(bool Function(T p1) predicate) async {
    List<T> all = await getAll();
    return all.any(predicate);
  }

  @override
  Future<void> remove(bool Function(T p1) predicate) async {
    List<T> all = await getAll();
    int index = all.indexWhere(predicate);
    if (index > 0) {
      all.removeAt(index);
      await replace(all);
    }
  }

  @override
  Future<T?> last() async {
    List<T> all = await getAll();
    if (all.isNotEmpty) return all.last;
    return null;
  }
}
