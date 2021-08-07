import 'package:flutter/material.dart';
import '../../presentation/shared-widgets/custom-drawer.dart';

class CustomPageWrapper extends StatelessWidget {
  final Widget? child;
  final Widget? floatingButton;
  final String? pageTitle;

  CustomPageWrapper({this.child, this.floatingButton, this.pageTitle});

  @override
  Widget build(BuildContext context) {
    double radius = 0;
    return Scaffold(
      drawer: Drawer(
        child: CustomDrawer(),
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
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                ),
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
