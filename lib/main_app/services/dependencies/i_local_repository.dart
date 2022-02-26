abstract class ILocalRepository<T> {
  Future<List<T>> getAll();
  Future<void> replace(List<T> newItems);
  Future<void> merge(List<T> newItems, String identifier);
  Future<void> add(T newItem);
}