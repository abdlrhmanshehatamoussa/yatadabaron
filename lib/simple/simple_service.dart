abstract class ISimpleService {
  Type get getAs;
}

class SimpleServiceProvider {
  final List<ISimpleService> _services;
  SimpleServiceProvider(this._services);

  T getService<T>() {
    int index =
        this._services.indexWhere((s) => s.getAs.toString() == T.toString());
    if (index == -1) {
      throw Exception("Unregistered service: ${T.toString()}");
    }
    return this._services[index] as T;
  }
}
