import 'interfaces.dart';

class SimpleServiceManager
    implements ISimpleServiceProvider, ISimpleServiceRegistery {
  final Map<String, ISimpleService> _map = <String, ISimpleService>{};

  @override
  void register<T>({required ISimpleService service}) {
    String key = T.toString();
    bool exists = _map.containsKey(key);
    if (exists) {
      throw Exception(
          "Error while registering service for type [$key], type already registered");
    } else {
      _map[T.toString()] = service;
    }
  }

  @override
  T getService<T>() {
    String key = T.toString();
    bool exists = _map.containsKey(key);
    if (exists == false) {
      throw Exception(
          "No services were registered for the type [$key], please register!");
    }
    return _map[key] as T;
  }
}
