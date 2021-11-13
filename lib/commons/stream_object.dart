import 'dart:async';
import 'package:rxdart/rxdart.dart';

class StreamObject<T> {
  StreamObject({T? initialValue}) {
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
