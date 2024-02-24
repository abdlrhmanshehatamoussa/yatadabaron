import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/main.dart';

class MushafTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mushafTypeService = Simply.get<IMushafTypeService>();
    MushafType current = mushafTypeService.getMushafType();
    return GestureDetector(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.arrow_drop_down),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "رواية " + current.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  //color: Theme.of(context).colorScheme.secondary,
                  fontFamily: current.fontName,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        await mushafTypeService.toggleMushafType();
        await appReload.call("");
      },
    );
  }
}
