import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/viewmodels/home_grid_item.dart';
import 'gird_item.dart';

class HomeGrid extends StatelessWidget {
  final List<HomeGridItemViewModel> items;
  const HomeGrid({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> gridItems = items
        .map((HomeGridItemViewModel item) => HomeGridItem(
              icon: item.icon,
              onTap: item.onTap,
              title: item.title,
            ))
        .toList();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      padding: EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: gridItems,
      ),
    );
  }
}
