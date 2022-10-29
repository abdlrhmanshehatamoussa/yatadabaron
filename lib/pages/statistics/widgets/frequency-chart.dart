import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';
import '../view_models/statistics-payload.dart';

class FrequencyChart extends StatelessWidget {
  final Stream<StatisticsPayload> payloadStream;

  const FrequencyChart({
    required this.payloadStream,
  });

  List<BarChartGroupData> _getBarGroupData(
      List<LetterFrequency> freqs, Color color) {
    var result = <BarChartGroupData>[];
    for (var i = 0; i < freqs.length; i++) {
      var freq = freqs[i];
      result.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
              toY: double.parse(freq.frequency.toString()), color: color)
        ],
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Color fillColor = Theme.of(context).colorScheme.secondary;
    Color? axisColor = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: EdgeInsets.all(3),
      child: StreamBuilder<StatisticsPayload>(
        stream: this.payloadStream,
        builder: (_, AsyncSnapshot<StatisticsPayload> snapshot) {
          if (snapshot.hasData) {
            var freqs = snapshot.data!.results
                .where((element) => element.frequency > 0)
                .toList();
            return Container(
              padding: EdgeInsets.all(10),
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                  ),
                  maxY: freqs.map((e) => e.frequency).reduce(max) * 1.0,
                  minY: 0,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${freqs[group.x].letter}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY.round()).toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                    show: false,
                  ),
                  barGroups: _getBarGroupData(freqs, fillColor),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) {
                          String text = value.round().toString();
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 5,
                            child: Text(
                              text,
                              style: TextStyle(
                                color: axisColor,
                                fontFamily: "Usmani",
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                        reservedSize: 40,
                        showTitles: true,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          var letter = freqs[value.round()].letter;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 30,
                            child: Text(
                              letter,
                              style: TextStyle(color: axisColor),
                            ),
                          );
                        },
                        showTitles: true,
                      ),
                    ),
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
