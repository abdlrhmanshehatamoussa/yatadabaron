import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/pages/drawer/view.dart';
import 'controller.dart';
import './widgets/frequency-chart.dart';
import './widgets/frequency-table.dart';
import './widgets/statistics-form.dart';
import './widgets/statistics-summary.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ControllerManager manager = Provider.of<ControllerManager>(context);
    StatisticsController controller = Provider.of<StatisticsController>(context);

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

    return CustomPageWrapper(
      drawer: Provider(
        create: (_) => manager.drawerController(),
        child: CustomDrawer(),
      ),
      pageTitle: Localization.DRAWER_STATISTICS,
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
}
