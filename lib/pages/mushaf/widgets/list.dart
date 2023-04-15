import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/search/controller.dart';
import 'package:yatadabaron/pages/search/view.dart';

class VerseList extends StatelessWidget {
  final List<Verse> verses;
  final int startFromVerse;
  final int? highlightedVerse;
  final IconData? iconData;
  final bool showEmla2y;
  final Function(Verse verse) onItemTap;
  final Function(Verse verse) onItemLongTap;

  const VerseList({
    required this.verses,
    required this.onItemTap,
    required this.iconData,
    required this.showEmla2y,
    required this.startFromVerse,
    required this.highlightedVerse,
    required this.onItemLongTap,
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
        String verseBody = verse.verseTextTashkel +
            " " +
            Utils.convertToArabiNumber(verse.verseID, reverse: false);
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
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: verseBody,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 28,
                        fontFamily: "Usmani",
                        color: isHighlighted
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: showEmla2y
                  ? SelectableText(
                      verse.verseText,
                      style: TextStyle(fontSize: 15),
                      contextMenuBuilder: (context, editableTextState) {
                        return AdaptiveTextSelectionToolbar(
                          anchors: editableTextState.contextMenuAnchors,
                          children: [
                            InkWell(
                              onTap: () async {
                                var selected = editableTextState
                                    .currentTextEditingValue.text
                                    .substring(
                                  editableTextState
                                      .currentTextEditingValue.selection.start,
                                  editableTextState
                                      .currentTextEditingValue.selection.end,
                                );
                                var controller = SearchController();
                                await controller
                                    .changeSettings(KeywordSearchSettings(
                                  basmala: false,
                                  keyword: selected,
                                  chapterID: null,
                                ));
                                appNavigator.pushWidget(
                                    view: SearchPage(controller: controller));
                              },
                              child: Container(
                                child: SizedBox(
                                  child: Text('بحث في القرآن'),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                            )
                          ],
                        );
                      },
                    )
                  : null,
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
