import 'package:flutter/material.dart';
import 'package:yatadabaron/models/module.dart';

class TafseerSelector extends StatelessWidget {
  final List<TafseerSource> tafseers;
  final int tafseerId;
  final Function(int tafseerSourceId) onTafseerSourceSelected;

  TafseerSelector({
    required this.tafseers,
    required this.tafseerId,
    required this.onTafseerSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      child: DropdownButton<int>(
        items: tafseers.map((TafseerSource dto) {
          return DropdownMenuItem<int>(
            child: Text(dto.tafseerName),
            value: dto.tafseerId,
          );
        }).toList(),
        value: tafseerId,
        onChanged: (int? selection) async {
          if (selection != null) {
            await onTafseerSourceSelected(selection);
          }
        },
      ),
    );
  }
}
