import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/_widgets/custom_search_toolbar.dart';

class VerseList extends StatelessWidget {
  final List<Verse> verses;
  final int startFromVerse;
  final int? highlightedVerse;
  final IconData? iconData;
  final bool searchable;
  final Function(Verse verse) onItemTap;
  final Function(Verse verse) onItemLongTap;

  const VerseList({
    required this.verses,
    required this.onItemTap,
    required this.iconData,
    required this.startFromVerse,
    required this.highlightedVerse,
    required this.onItemLongTap,
    required this.searchable,
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
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Theme.of(context).colorScheme.primary),
      itemBuilder: (context, i) {
        Verse verse = verses[i];
        bool isHighlighted = verse.verseID == (highlightedVerse ?? 0);
        return Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.antiAlias,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(
                top: isHighlighted ? 20 : 5,
                left: 5,
                right: 10,
              ),
              title: Text(
                verse.verseTextTashkel +
                    " " +
                    Utils.convertToArabiNumber(verse.verseID, reverse: false),
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 28,
                  fontFamily: "Usmani",
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
              ),
              subtitle: SelectableText(
                verse.verseText,
                style: TextStyle(fontSize: 20),
                contextMenuBuilder: (context, editableTextState) {
                  return searchable
                      ? CustomSerachToolbar(
                          editableTextState: editableTextState,
                          chapterId: verse.chapterId,
                        )
                      : AdaptiveTextSelectionToolbar.editableText(
                          editableTextState: editableTextState,
                        );
                },
              ),
              selected: isHighlighted,
              onTap: () async => await this.onItemTap(verse),
              onLongPress: () async => await this.onItemLongTap(verse),
            ),
            isHighlighted
                ? Container(
                    child: Icon(
                      iconData,
                      size: 15,
                    ),
                    padding: EdgeInsets.all(5),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
