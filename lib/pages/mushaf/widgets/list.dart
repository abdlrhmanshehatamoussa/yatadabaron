import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';

class VerseList extends StatelessWidget {
  final List<Verse> verses;
  final int startFromVerse;
  final int? highlightedVerse;
  final IconData? iconData;
  final bool showEmla2y;
  final Function(Verse verse) onItemTap;

  const VerseList({
    required this.verses,
    required this.onItemTap,
    required this.iconData,
    required this.showEmla2y,
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
        Verse verse = verses[i];
        Color? color;
        bool isHighlighted = verse.verseID == (highlightedVerse ?? 0);
        if (isHighlighted) {
          color = Theme.of(context).colorScheme.secondary;
        }
        String verseBody = verse.verseTextTashkel;
        String verseIdStr = Utils.convertToArabiNumber(verse.verseID, reverse: false);
        verseBody = "$verseBody $verseIdStr";
        Widget icon = Container();
        if (isHighlighted) {
          icon = Container(
            child: Icon(iconData),
            padding: EdgeInsets.all(5),
          );
        }
        Widget? subtitle;
        if (showEmla2y) {
          subtitle = Text(verse.verseText,style: TextStyle(fontSize: 15),);
        }
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
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: subtitle,
              selected: isHighlighted,
              onTap: () async => await this.onItemTap(verse),
            ),
            icon,
          ],
        );
      },
    );
  }
}
