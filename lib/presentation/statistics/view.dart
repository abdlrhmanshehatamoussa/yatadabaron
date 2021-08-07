import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Yatadabaron/presentation/statistics/viewmodel.dart';
import '../../presentation/shared-widgets/custom-page-wrapper.dart';
import '../../presentation/shared-widgets/loading-widget.dart';
import 'package:Yatadabaron/presentation/statistics/widgets/frequency-chart.dart';
import 'package:Yatadabaron/presentation/statistics/widgets/frequency-table.dart';
import 'package:Yatadabaron/presentation/statistics/widgets/statistics-form.dart';
import 'package:Yatadabaron/presentation/statistics/widgets/statistics-summary.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget resultsArea = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StatisticsSummaryWidget(),
        Divider(),
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

    StatisticsBloc bloc = Provider.of<StatisticsBloc>(context);
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
}
