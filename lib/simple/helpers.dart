import 'package:rxdart/rxdart.dart';

class SimpleStreamObject<T> {
  SimpleStreamObject({T? initialValue}) {
    if (initialValue != null) {
      add(initialValue);
    }
  }
  final BehaviorSubject<T> _controller = BehaviorSubject<T>();
  Stream<T> get stream => _controller.stream;
  T get value => _controller.value;
  Function(T) get add => _controller.sink.add;
  dispose() {
    _controller.close();
  }
}
