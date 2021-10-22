import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import '../controller.dart';
import 'package:charts_flutter/flutter.dart' as Charts;

class FrequencyChart extends StatelessWidget {
  List<Charts.Series<LetterFrequency, String>> _getSeries(
      List<LetterFrequency> freqs, Color color) {
    List<Charts.Series<LetterFrequency, String>> seriesList = [
      Charts.Series<LetterFrequency, String>(
        id: "letter frequencies",
        fillColorFn: (_, __) => Charts.ColorUtil.fromDartColor(color),
        domainFn: (LetterFrequency f, _) => f.letter,
        measureFn: (LetterFrequency f, _) => f.frequency,
        data: freqs.where((x) => x.frequency > 0).toList(),
      )
    ];
    return seriesList;
  }

  @override
  Widget build(BuildContext context) {
    StatisticsController bloc = Provider.of<StatisticsController>(context);
    Color fillColor = Theme.of(context).colorScheme.secondary;
    Color? axisColor = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: EdgeInsets.all(3),
      child: StreamBuilder<StatisticsPayload>(
        stream: bloc.payloadStream,
        builder: (_, AsyncSnapshot<StatisticsPayload> snapshot) {
          if (snapshot.hasData) {
            List<Charts.Series<LetterFrequency, String>> series =
                _getSeries(snapshot.data!.results, fillColor);
            return Charts.BarChart(
              series,
              primaryMeasureAxis: Charts.NumericAxisSpec(
                tickProviderSpec: Charts.BasicNumericTickProviderSpec(
                    desiredMinTickCount: 10),
                renderSpec: Charts.GridlineRendererSpec(
                    labelStyle: Charts.TextStyleSpec(
                      color: Charts.ColorUtil.fromDartColor(axisColor),
                    ),
                    lineStyle: Charts.LineStyleSpec(thickness: 0)),
              ),
              domainAxis: Charts.OrdinalAxisSpec(
                renderSpec: Charts.SmallTickRendererSpec(
                  labelStyle: Charts.TextStyleSpec(
                    color: Charts.ColorUtil.fromDartColor(axisColor),
                  ),
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
