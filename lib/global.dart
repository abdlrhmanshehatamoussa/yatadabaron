import 'dart:async';
import 'package:flutter/material.dart';
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

extension networkTimeoutExtensions<T> on Future<T> {
  Future<T> defaultNetworkTimeout({int? seconds}) {
    return this.timeout(
      Duration(
        seconds: seconds ?? 5,
      ),
    );
  }
}

extension NavigationExtensions on NavigatorState {
  pushWidget({required Widget view}) {
    return this.push(MaterialPageRoute(
      builder: (context) => view,
    ));
  }

  pushReplacementWidget({required Widget view}) {
    return this.pushReplacement(MaterialPageRoute(
      builder: (context) => view,
    ));
  }
}
