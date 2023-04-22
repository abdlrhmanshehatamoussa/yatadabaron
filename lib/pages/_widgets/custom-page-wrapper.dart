import 'package:flutter/material.dart';

class CustomPageWrapper extends StatelessWidget {
  final Widget? child;
  final Widget? floatingButton;
  final Widget? drawer;
  final String? pageTitle;
  final bool centered;

  CustomPageWrapper({
    required this.child,
    this.pageTitle,
    this.drawer,
    this.floatingButton,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        this.pageTitle ?? "",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      drawer: (drawer != null) ? Drawer(child: drawer) : null,
      appBar: (pageTitle != null) ? appBar : null,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: centered ? Alignment.center : null,
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
