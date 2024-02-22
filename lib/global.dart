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

extension StringExtensions on String {
  bool isRemoteUrl() {
    return startsWith("https://") || startsWith("http://");
  }

  String toArabicNumber() {
    return replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }
}

extension IntExtensions on int {
  String toArabicNumber() {
    return toString().toArabicNumber();
  }
}
