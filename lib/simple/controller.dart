abstract class ISimpleController {}

abstract class ISimpleControllerProvider {
  T getController<T>();
}

class EagerControllerProvider implements ISimpleControllerProvider {
  EagerControllerProvider(this._controllers);
  final List<ISimpleController> _controllers;

  @override
  T getController<T>() {
    int index = this
        ._controllers
        .indexWhere((s) => s.runtimeType.toString() == T.toString());
    if (index == -1) {
      throw Exception("Unregistered controller: ${T.toString()}");
    }
    return this._controllers[index] as T;
  }
}
