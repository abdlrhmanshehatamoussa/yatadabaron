import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/modules/domain.module.dart';

import '../bloc.dart';

class TafseerSelector extends StatelessWidget {
  final List<TafseerSource> tafseers;
  final int tafseerId;

  TafseerSelector({
    required this.tafseers,
    required this.tafseerId,
  });

  @override
  Widget build(BuildContext context) {
    TafseerPageBloc bloc = Provider.of(context);
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
        onChanged: (int? selection) {
          if (selection != null) {
            bloc.updateTafseerStream(selection);
          }
        },
      ),
    );
  }
}
