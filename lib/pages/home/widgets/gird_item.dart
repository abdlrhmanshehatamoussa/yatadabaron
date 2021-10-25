import 'package:flutter/material.dart';

class HomeGridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const HomeGridItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Column(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 35,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
