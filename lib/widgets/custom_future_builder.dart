import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget loading;
  final Widget Function(String)? error;
  final Widget Function(T) done;

  const CustomFutureBuilder({
    required this.future,
    required this.loading,
    required this.done,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (_, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return done(snapshot.data!);
        } else if (snapshot.hasError) {
          if (error != null) {
            return error!(snapshot.error.toString());
          } else {
            return loading;
          }
        } else {
          return loading;
        }
      },
    );
  }
}
