import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';

class HomeHeader extends StatelessWidget {
  final Function drawerOnTap;
  final double? size;
  const HomeHeader({
    Key? key,
    required this.drawerOnTap,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.size,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Center(
              child: RawMaterialButton(
                onPressed: () => this.drawerOnTap(),
                child: new Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.background,
                  size: 20,
                ),
                fillColor: Theme.of(context).colorScheme.secondary,
                shape: new CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Text(
                  Localization.APP_TITLE,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
