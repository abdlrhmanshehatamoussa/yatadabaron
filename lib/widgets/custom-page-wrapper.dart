import 'package:flutter/material.dart';

class CustomPageWrapper extends StatelessWidget {
  final Widget? child;
  final Widget? floatingButton;
  final Widget? drawer;
  final String pageTitle;

  CustomPageWrapper({
    required this.child,
    required this.pageTitle,
    required this.drawer,
    this.floatingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (drawer != null) ? Drawer(child: drawer) : null,
      appBar: AppBar(
        title: Text(
          this.pageTitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
