import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import '../controller.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class FrequencyTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: Remove dependency on controller and pass direct parameters to the widget
    StatisticsController bloc = Provider.of<StatisticsController>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.center,
        child: StreamBuilder<StatisticsPayload>(
          stream: bloc.payloadStream,
          builder: (_, AsyncSnapshot<StatisticsPayload> snapshot) {
            if (snapshot.hasData) {
              return DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      Localization.LETTER,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      Localization.FREQUENCY,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: snapshot.data!.results.map((LetterFrequency lf) {
                  String freq = ArabicNumbersService.instance.convert(
                    lf.frequency,
                    reverse: false,
                  );
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          lf.letter,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          freq,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }
            return LoadingWidget();
          },
        ),
      ),
    );
  }
}
