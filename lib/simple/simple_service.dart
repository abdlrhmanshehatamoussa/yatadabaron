abstract class SimpleService<T> {
  String get serviceId => T.toString();
}

class SimpleServiceProvider {
  final List<SimpleService> _services;
  SimpleServiceProvider(this._services);

  T getService<T>() {
    int index = this._services.indexWhere((s) => s.serviceId == T.toString());
    if (index == -1) {
      throw Exception("Unregistered service: ${T.toString()}");
    }
    return this._services[index] as T;
  }
}