import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/statistics/backend.dart';
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
    StatisticsBackend backend = StatisticsBackend();
    Widget resultsArea = Column(
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

    Widget initialMessage = Text(
      Localization.TAP_STAT_BUTTON,
      style: Utils.emptyListStyle(),
    );

    return CustomPageWrapper(
      pageTitle: Localization.QURAN_STATISTICS,
      child: StreamBuilder<SearchState>(
        stream: backend.stateStream,
        builder: (_, AsyncSnapshot<SearchState> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case SearchState.INITIAL:
                return initialMessage;
              case SearchState.IN_PROGRESS:
                return LoadingWidget();
              case SearchState.DONE:
                return resultsArea;
              default:
                return initialMessage;
            }
          }
          return LoadingWidget();
        },
      ),
      floatingButton: FloatingActionButton(
        child: Icon(Icons.insert_chart),
        mini: true,
        onPressed: () async {
          await StatisticsForm.show(
            context: context,
            chaptersFuture: backend.getMushafChapters(),
            onFormSubmit: (BasicSearchSettings searchSettings) async {
              await backend.changeSettings(searchSettings);
            },
          );
        },
      ),
    );
  }
}
