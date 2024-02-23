import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class ReciterSelector extends StatelessWidget {
  final String? initialValue;
  final Function(String?)? onChanged;

  final tarteelService = Simply.get<ITarteelService>();
  final mushafTypeService = Simply.get<IMushafTypeService>();

  MushafType get currentMushafType => mushafTypeService.getMushafType();

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
      items: tarteelService
          .getReciterKeys(currentMushafType)
          .map((reciterKey) => DropdownMenuItem<String>(
                key: UniqueKey(),
                child: SingleChildScrollView(
                  child: Text(tarteelService.getReciterName(reciterKey)),
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
