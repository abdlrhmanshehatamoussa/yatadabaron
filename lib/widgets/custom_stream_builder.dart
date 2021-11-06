import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget loading;
  final Widget Function(String)? error;
  final Widget Function(T) done;

  const CustomStreamBuilder({
    required this.stream,
    required this.loading,
    required this.done,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
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
