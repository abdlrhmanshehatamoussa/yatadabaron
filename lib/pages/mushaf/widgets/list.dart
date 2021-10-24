import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/widgets/module.dart';
import 'list-item.dart';

class VerseList extends StatelessWidget {
  final Stream<List<Verse>> versesStream;
  final Function(Verse verse) onItemTap;

  const VerseList({
    required this.versesStream,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    ItemScrollController _scrollController = ItemScrollController();

    return StreamBuilder<List<Verse>>(
      stream: this.versesStream,
      builder: (BuildContext context, AsyncSnapshot<List<Verse>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<Verse> results = snapshot.data!;
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
          int selectedVerseId =
              results.firstWhere((v) => v.isSelected).verseID;
          scrollIndex = selectedVerseId - 1;
        }
        return ScrollablePositionedList.separated(
          itemScrollController: _scrollController,
          itemCount: results.length,
          initialScrollIndex: scrollIndex,
          separatorBuilder: (_, __) {
            return Divider(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            );
          },
          itemBuilder: (context, i) {
            Verse result = results[i];
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
              leading: (result.isBookmark) ? Icon(Icons.bookmark) : null,
              onTap: () async => await this.onItemTap(result),
            );
          },
        );
      },
    );
  }
}
