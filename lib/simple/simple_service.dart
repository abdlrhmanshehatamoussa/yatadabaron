abstract class SimpleService<T> {
  String get serviceId => T.toString();
}

class SimpleServiceProvider {
  final List<SimpleService> _services;
  SimpleServiceProvider(this._services);

  T getService<T>() {
    return this._services.firstWhere((s) => s.serviceId == T.toString()) as T;
  }
}
