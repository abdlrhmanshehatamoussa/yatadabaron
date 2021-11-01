import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/statistics/controller.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import './widgets/frequency-chart.dart';
import './widgets/frequency-table.dart';
import './widgets/statistics-form.dart';
import './widgets/statistics-summary.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class StatisticsPage extends SimpleView<StatisticsController> {
  @override
  Widget build(BuildContext context) {
    StatisticsController controller = getController(context);
    Widget resultsArea = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StatisticsSummaryWidget(
          payloadStream: controller.payloadStream,
        ),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: FrequencyChart(
            payloadStream: controller.payloadStream,
          ),
          flex: 1,
        ),
        Divider(),
        Expanded(
          child: FrequencyTable(
            payloadStream: controller.payloadStream,
          ),
          flex: 1,
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
        stream: controller.stateStream,
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
        onPressed: () {
          StatisticsForm.show(context, controller);
        },
      ),
    );
  }

  @override
  StatisticsController provideController(
    ISimpleServiceProvider serviceProvider,
  ) {
    return StatisticsController(
      analyticsService: serviceProvider.getService<IAnalyticsService>(),
      chaptersService: serviceProvider.getService<IChaptersService>(),
      versesService: serviceProvider.getService<IVersesService>(),
    );
  }
}
