import 'package:yatadabaron/commons/localization.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  ErrorDialog(this.message);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(Localization.ERROR),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Text(this.message),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(Localization.CLOSE),
        )
      ],
    );
  }

  static show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(message);
      },
    );
  }
}
