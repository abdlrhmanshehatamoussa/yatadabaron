import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc.dart';

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
              child: Text(
                snapshot.data!.summary,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
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
