import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/app_start/controller_manager.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:yatadabaron/widgets/module.dart';
import '../controller.dart';
import 'list-item.dart';

class VerseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ControllerManager manager = Provider.of<ControllerManager>(context);
    MushafController mushafController = manager.mushafController();
    ItemScrollController _scrollController = ItemScrollController();

    _navigate(Verse result) {
      if (result.verseID != null && result.chapterId != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Provider(
            child: TafseerPage(),
            create: (_) => manager.tafseerPageController(
              verseId: result.verseID!,
              chapterId: result.chapterId!,
              onBookmarkSaved: () {
                mushafController.reloadVerses(result.chapterId, result.verseID);
              },
            ),
          ),
        ));
      }
    }

    return StreamBuilder<List<Verse>>(
      stream: mushafController.versesStream,
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
              results.firstWhere((v) => v.isSelected).verseID!;
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
              onTap: () async => _navigate(result),
            );
          },
        );
      },
    );
  }
}
