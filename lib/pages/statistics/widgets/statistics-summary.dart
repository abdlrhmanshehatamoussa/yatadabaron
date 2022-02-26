import 'package:yatadabaron/pages/_widgets/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view_models/statistics-payload.dart';

class StatisticsSummaryWidget extends StatelessWidget {
  final Stream<StatisticsPayload> payloadStream;

  const StatisticsSummaryWidget({
    Key? key,
    required this.payloadStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<StatisticsPayload>(
        stream: this.payloadStream,
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
                    fontFamily: "Arial"),
              ),
            );
          }
          return LoadingWidget();
        },
      ),
    );
  }
}
