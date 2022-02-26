abstract class ILocalRepository<T> {
  Future<List<T>> getAll();
  Future<void> replace(List<T> newItems);
  Future<void> addBulk(List<T> newItems);
  Future<void> merge(List<T> newItems);
  Future<void> add(T newItem);
}
