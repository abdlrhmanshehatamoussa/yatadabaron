import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final String text;

  const CustomCircularProgressIndicator({
    Key? key,
    required this.radius,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: radius,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: radius,
                  height: radius,
                  child: new CircularProgressIndicator(
                    strokeWidth: 15,
                  ),
                ),
              ),
              Center(child: Text(text)),
            ],
          ),
        ),
      ],
    );
  }
}
