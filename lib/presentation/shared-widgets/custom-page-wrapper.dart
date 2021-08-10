import 'package:Yatadabaron/presentation/modules/pages.module.dart';
import 'package:flutter/material.dart';

class CustomPageWrapper extends StatelessWidget {
  final Widget? child;
  final Widget? floatingButton;
  final String? pageTitle;

  CustomPageWrapper({this.child, this.floatingButton, this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: CustomDrawer.providedWithBloc(),
      ),
      appBar: AppBar(
        title: Text(
          this.pageTitle!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: this.child,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: this.floatingButton,
    );
  }
}
