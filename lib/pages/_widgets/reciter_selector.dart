import 'package:flutter/material.dart';
import '../../global.dart';

class ReciterSelector extends StatelessWidget {
  final String? initialValue;
  final Function(String?)? onChanged;

  ReciterSelector({
    Key? key,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      key: UniqueKey(),
      isExpanded: true,
      items: reciterNameMap.keys
          .map((reciterKey) => DropdownMenuItem<String>(
                key: UniqueKey(),
                child: SingleChildScrollView(
                  child: Text(reciterNameMap[reciterKey] ?? ""),
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                ),
                value: reciterKey,
              ))
          .toList(),
      onChanged: onChanged,
      value: initialValue,
    );
  }
}
