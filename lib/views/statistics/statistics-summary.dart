import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/statistics-bloc.dart';
import '../../dtos/statistics-payload.dart';
import '../../views/shared-widgets/loading-widget.dart';

class StatisticsSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatisticsBloc bloc = Provider.of<StatisticsBloc>(context);
    return Center(
      child: StreamBuilder<StatisticsPayload>(
        stream: bloc.payloadStream,
        builder: (_, AsyncSnapshot<StatisticsPayload> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(12),
              color: Theme.of(context).cardColor,
              child: Text(
                snapshot.data!.summary,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Arial"
                ),
              ),
            );
          }
          return LoadingWidget();
        },
      ),
    );
  }
}
