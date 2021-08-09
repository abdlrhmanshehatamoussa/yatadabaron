import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/presentation/shared-widgets.module.dart';
import 'package:Yatadabaron/presentation/mushaf/widgets/list-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';

import '../bloc.dart';

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
        List<VerseDTO> results = snapshot.data!;
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
          int selectedVerseId = results.firstWhere((v) => v.isSelected).verseID!;
          scrollIndex = selectedVerseId - 1;
        }
        return ScrollablePositionedList.separated(
          itemScrollController: _scrollController,
          itemCount: results.length,
          initialScrollIndex: scrollIndex,
          separatorBuilder: (_, __) {
            return Divider(
              color: Colors.white70,
            );
          },
          itemBuilder: (context, i) {
            VerseDTO result = results[i];
            Color? color;
            if (result.isSelected) {
              color = Theme.of(context).colorScheme.secondary;
            }
            return ListTile(
              title: MushafVerseListItem(
                text: result.verseTextTashkel,
                verseID: result.verseID,
                color: color,
              ),
              selected: result.isSelected,
              leading:
                  (result.isBookmark) ? Icon(Icons.bookmark) : null,
              onTap: () {
                String toCopy =
                    "${result.chapterName}\n${result.verseTextTashkel} {${result.verseID}}";
                Share.share(toCopy);
              },
              onLongPress: () async {
                //Save the bookmark
                await mushafBloc.saveBookmark(result.chapterId!, result.verseID!);
                Utils.showCustomDialog(
                  context: context,
                  title: Localization.BOOKMARK_SAVED,
                );
              },
            );
          },
        );
      },
    );
  }
}
