import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/arabic-numbers-service.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class FrequencyTable extends StatelessWidget {
  final Stream<StatisticsPayload> payloadStream;

  const FrequencyTable({
    required this.payloadStream,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.center,
        child: StreamBuilder<StatisticsPayload>(
          stream: this.payloadStream,
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
