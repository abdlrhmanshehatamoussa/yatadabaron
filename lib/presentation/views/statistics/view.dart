import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import './widgets/frequency-chart.dart';
import './widgets/frequency-table.dart';
import './widgets/statistics-form.dart';
import './widgets/statistics-summary.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget resultsArea = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StatisticsSummaryWidget(),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: FrequencyChart(),
          flex: 1,
        ),
        Divider(),
        Expanded(
          child: FrequencyTable(),
          flex: 1,
        ),
      ],
    );

    Widget initialMessage = Text(
      Localization.TAP_STAT_BUTTON,
      style: Utils.emptyListStyle(),
    );

    StatisticsController bloc = Provider.of<StatisticsController>(context);
    return CustomPageWrapper(
      pageTitle: Localization.DRAWER_STATISTICS,
      child: StreamBuilder<SearchState>(
        stream: bloc.stateStream,
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
          StatisticsForm.show(context, bloc);
        },
      ),
    );
  }

  static void pushReplacement(BuildContext context) {
    Navigator.of(context).pushReplacement(_getPageRoute());
  }

  static MaterialPageRoute _getPageRoute() {
    return MaterialPageRoute(
      builder: (context) => Provider(
        child: StatisticsPage(),
        create: (context) => StatisticsController(),
      ),
    );
  }
}
