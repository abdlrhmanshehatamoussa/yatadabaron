import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';

class SearchSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SearchSessionBloc bloc = Provider.of<SearchSessionBloc>(context);
    return StreamBuilder<SearchSessionPayload>(
      stream: bloc.payloadStream,
      builder:
          (BuildContext context, AsyncSnapshot<SearchSessionPayload> snapshot) {
        SearchSessionPayload? searchSummary = snapshot.data;
        if (searchSummary == null) {
          return LoadingWidget();
        }
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
          color: Theme.of(context).cardColor,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text(
                  searchSummary.summary,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: "Arial"
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  child: Icon(Icons.share),
                  onPressed: () async {
                    snapshot.data!.copyAll();
                  },
                  mini: true,
                  heroTag: null,
                ),
                flex: 1,
              )
            ],
          ),
        );
      },
    );
  }
}
