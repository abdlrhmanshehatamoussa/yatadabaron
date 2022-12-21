abstract class IRemoteRepository<T> {
  Future<List<T>> fetchAll();
}
