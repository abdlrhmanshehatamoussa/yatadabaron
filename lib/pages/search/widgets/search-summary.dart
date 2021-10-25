import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view_models/search-session-payload.dart';
import 'package:yatadabaron/widgets/module.dart';

class SearchSummaryWidget extends StatelessWidget {
  final Stream<SearchSessionPayload> payloadStream;
  final Function(SearchSessionPayload payload) onPressed;

  const SearchSummaryWidget({
    required this.payloadStream,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchSessionPayload>(
      stream: this.payloadStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<SearchSessionPayload> snapshot,
      ) {
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
                    fontFamily: "Arial",
                  ),
                ),
              ),
              Expanded(
                child: FloatingActionButton(
                  child: Icon(Icons.share),
                  onPressed: () async => await this.onPressed(searchSummary),
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
