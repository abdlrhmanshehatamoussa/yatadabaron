import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/statistics-bloc.dart';
import '../../dtos/letter-frequency.dart';
import '../../dtos/statistics-payload.dart';
import '../../helpers/localization.dart';
import '../../views/shared-widgets/loading-widget.dart';

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
                    label: Text(Localization.LETTER,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  DataColumn(
                    label: Text(Localization.FREQUENCY,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ],
                rows: snapshot.data.results.map((LetterFrequency lf) {
                  return DataRow(
                    cells: [
                      DataCell(Text(lf.letter)),
                      DataCell(Text(lf.frequency.toString())),
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
