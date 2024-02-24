import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';

class MushafTypeSelector extends StatefulWidget {
  @override
  _MushafTypeSelectorState createState() => _MushafTypeSelectorState();
}

class _MushafTypeSelectorState extends State<MushafTypeSelector> {
  final mushafTypeService = Simply.get<IMushafTypeService>();

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: current.fontName,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        await mushafTypeService.toggleMushafType();
        setState(() {});
        Utils.showCustomDialog(
          context: context,
          title: "تم تغيير الرواية",
          text: "برجاء ملاحظة فرق الخطوط وأعداد الآيات بين الروايات.",
        );
      },
    );
  }
}
