import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchSummaryWidget extends StatelessWidget {
  final String summary;
  final Function() onPressed;

  const SearchSummaryWidget({
    required this.summary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              summary,
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
              onPressed: () async => await this.onPressed(),
              mini: true,
              heroTag: null,
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
