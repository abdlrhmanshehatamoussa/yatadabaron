import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import '../controller.dart';

class SearchSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: Remove dependency on controller and pass direct parameters to the widget
    HomeController controller = Provider.of<HomeController>(context);
    return StreamBuilder<SearchSessionPayload>(
      stream: controller.payloadStream,
      builder:
          (BuildContext context, AsyncSnapshot<SearchSessionPayload> snapshot) {
        SearchSessionPayload? searchSummary = snapshot.data;
        if (searchSummary == null) {
          return LoadingWidget();
        }
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
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
                    await controller.copyAll(snapshot.data!);
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
