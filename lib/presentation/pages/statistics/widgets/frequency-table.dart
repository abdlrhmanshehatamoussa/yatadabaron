import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc.dart';
import '../view_model/statistics-payload.dart';

class FrequencyTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatisticsBloc bloc = Provider.of<StatisticsBloc>(context);
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
