import 'package:flutter/material.dart';

class HomeGridItemViewModel {
  final String title;
  final IconData icon;
  final Function onTap;

  HomeGridItemViewModel({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
