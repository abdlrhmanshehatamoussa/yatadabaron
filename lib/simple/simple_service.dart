abstract class ISimpleService {
  Type get getAs;
}

abstract class ISimpleServiceProvider {
  T getService<T>();
}

class EagerServiceProvider implements ISimpleServiceProvider {
  final List<ISimpleService> _services;
  EagerServiceProvider(this._services);

  @override
  T getService<T>() {
    int index =
        this._services.indexWhere((s) => s.getAs.toString() == T.toString());
    if (index == -1) {
      throw Exception("Unregistered service: ${T.toString()}");
    }
    return this._services[index] as T;
  }
}
