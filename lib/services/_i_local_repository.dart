abstract class ILocalRepository<T> {
  Future<List<T>> getAll();
  Future<void> replace(List<T> newItems);
  Future<void> addBulk(List<T> newItems);
  Future<void> merge(List<T> newItems, bool Function(T, T) compareFunction);
  Future<void> add(T newItem);
  Future<bool> any(bool Function(T) predicate);
  Future<void> remove(bool Function(T) predicate);
  Future<T?> last();
}
