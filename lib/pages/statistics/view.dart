import 'package:flutter/material.dart';
import 'package:yatadabaron/pages/statistics/controller.dart';
import './widgets/frequency-chart.dart';
import './widgets/frequency-table.dart';
import './widgets/statistics-form.dart';
import './widgets/statistics-summary.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/_widgets/module.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StatisticsController backend = StatisticsController();

    return StreamBuilder<SearchState>(
      stream: backend.stateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        Widget body;
        Widget? btn;
        switch (snapshot.data) {
          case SearchState.IN_PROGRESS:
            body = LoadingWidget();
            break;
          case SearchState.DONE:
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StatisticsSummaryWidget(
                  payloadStream: backend.payloadStream,
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: FrequencyChart(
                    payloadStream: backend.payloadStream,
                  ),
                  flex: 3,
                ),
                Divider(),
                Expanded(
                  child: FrequencyTable(
                    payloadStream: backend.payloadStream,
                  ),
                  flex: 2,
                ),
              ],
            );
            btn = FloatingActionButton(
              child: Icon(Icons.insert_chart),
              mini: true,
              onPressed: () {
                backend.resetState();
              },
            );
            break;
          case SearchState.INITIAL:
          default:
            body = StatisticsForm(
              onFormSubmit: (BasicSearchSettings searchSettings) async {
                await backend.changeSettings(searchSettings);
              },
              chaptersFuture: backend.getMushafChapters(),
            );
            break;
        }
        return CustomPageWrapper(
          pageTitle: Localization.QURAN_STATISTICS,
          centered: false,
          child: body,
          floatingButton: btn,
        );
      },
    );
  }
}
