import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/statistics-bloc.dart';
import '../../enums/enums.dart';
import '../../helpers/localization.dart';
import '../../helpers/utils.dart';
import '../../views/shared-widgets/custom-page-wrapper.dart';
import '../../views/shared-widgets/loading-widget.dart';
import '../../views/statistics/frequency-chart.dart';
import '../../views/statistics/frequency-table.dart';
import '../../views/statistics/statistics-form.dart';
import '../../views/statistics/statistics-summary.dart';

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
                break;
              case SearchState.IN_PROGRESS:
                return LoadingWidget();
                break;
              case SearchState.DONE:
                return resultsArea;
                break;
              default:
                return initialMessage;
                break;
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
