import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc.dart';

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
                  String freq = ArabicNumbersService.insance.convert(
                    lf.frequency,
                    reverse: false,
                  );
                  return DataRow(
                    cells: [
                      DataCell(Text(lf.letter)),
                      DataCell(
                        Text(
                          freq,
                          style: TextStyle(
                            fontFamily: 'Arial'
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
