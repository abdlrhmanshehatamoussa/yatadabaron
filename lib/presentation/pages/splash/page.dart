import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';

class Splash extends StatelessWidget {
  final Widget child;

  Splash(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/imgs/home.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: LogoTansparent(),
                flex: 1,
              ),
              Expanded(
                child: Center(
                  child: this.child,
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
