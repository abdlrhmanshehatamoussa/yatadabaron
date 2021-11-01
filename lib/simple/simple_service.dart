abstract class ISimpleService {}

abstract class ISimpleServiceProvider {
  T getService<T>();
}

abstract class ISimpleServiceRegistery {
  void register<T>({required ISimpleService service});
}