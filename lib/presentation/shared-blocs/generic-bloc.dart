import 'dart:async';

import 'package:rxdart/rxdart.dart';

class GenericBloc<T>{
  BehaviorSubject<T> _controller = BehaviorSubject<T>();
  Stream<T> get stream => _controller.stream;
  Function(T) get add => _controller.sink.add;
  dispose(){
    _controller.close();
  }
}