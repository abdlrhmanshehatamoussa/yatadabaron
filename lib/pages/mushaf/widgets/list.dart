import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'list-item.dart';

class VerseList extends StatelessWidget {
  final List<Verse> verses;
  final int startFromVerse;
  final int? highlightedVerse;
  final Function(Verse verse) onItemTap;

  const VerseList({
    required this.verses,
    required this.onItemTap,
    required this.startFromVerse,
    required this.highlightedVerse,
  });

  @override
  Widget build(BuildContext context) {
    if (verses.length == 0) {
      return Center(
        child: Text(
          Localization.EMPTY_SEARCH_RESULTS,
          style: Utils.emptyListStyle(),
        ),
      );
    }

    int scrollIndex = startFromVerse - 1;
    return ScrollablePositionedList.separated(
      itemScrollController: ItemScrollController(),
      itemCount: verses.length,
      initialScrollIndex: scrollIndex,
      separatorBuilder: (_, __) {
        return Divider(
          height: 1,
          color: Theme.of(context).colorScheme.primary,
        );
      },
      itemBuilder: (context, i) {
        Verse result = verses[i];
        Color? color;
        bool isHighlighted = result.verseID == (highlightedVerse ?? 0);
        if (isHighlighted) {
          color = Theme.of(context).colorScheme.secondary;
        }
        return ListTile(
          title: MushafVerseListItem(
            text: result.verseTextTashkel,
            verseID: result.verseID,
            color: color,
          ),
          selected: isHighlighted,
          leading: null,
          onTap: () async => await this.onItemTap(result),
        );
      },
    );
  }
}
