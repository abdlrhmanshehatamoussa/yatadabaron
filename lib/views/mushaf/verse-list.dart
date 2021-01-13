import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';
import '../../blocs/mushaf-bloc.dart';
import '../../dtos/verse-dto.dart';
import '../../helpers/localization.dart';
import '../../helpers/utils.dart';
import '../../views/shared-widgets/loading-widget.dart';

class VerseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MushafBloc mushafBloc = Provider.of<MushafBloc>(context);
    ItemScrollController _scrollController = ItemScrollController();

    return StreamBuilder<List<VerseDTO>>(
      stream: mushafBloc.versesStream,
      builder: (BuildContext context, AsyncSnapshot<List<VerseDTO>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<VerseDTO> results = snapshot.data;
        if (results.length == 0) {
          return Center(
            child: Text(
              Localization.EMPTY_SEARCH_RESULTS,
              style: Utils.emptyListStyle(),
            ),
          );
        }

        int scrollIndex = 0;
        if (results.any((v) => v.isSelected)) {
          int selectedVerseId = results.firstWhere((v) => v.isSelected).verseID;
          scrollIndex = selectedVerseId - 1;
        }
        return ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          itemCount: results.length,
          initialScrollIndex: scrollIndex,
          itemBuilder: (context, i) {
            VerseDTO result = results[i];
            String body = "${result.verseTextTashkel}";
            return ListTile(
              title: Text(
                body,
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
              ),
              selected: result.isSelected,
              leading: Text("${result.verseID}"),
              onTap: () {
                String toCopy =
                    "${result.chapterName}\n${result.verseTextTashkel} {${result.verseID}}";
                Share.share(toCopy);
              },
            );
          },
        );
      },
    );
  }
}
