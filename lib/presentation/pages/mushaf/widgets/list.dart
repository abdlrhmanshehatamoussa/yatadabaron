import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-widgets.module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../bloc.dart';
import 'list-item.dart';

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
              leading: (result.isBookmark) ? Icon(Icons.bookmark) : null,
              onTap: () async => await mushafBloc.onVerseTap(result, context),
            );
          },
        );
      },
    );
  }
}
