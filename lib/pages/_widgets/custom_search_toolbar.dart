import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';

import '../search/controller.dart';
import '../search/view.dart';

class CustomSerachToolbar extends StatelessWidget {
  final EditableTextState editableTextState;
  final int? chapterId;

  const CustomSerachToolbar({
    Key? key,
    required this.editableTextState,
    required this.chapterId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextSelectionToolbar(
      anchors: editableTextState.contextMenuAnchors,
      children: [
        InkWell(
          onTap: () async {
            var selected =
                editableTextState.currentTextEditingValue.text.substring(
              editableTextState.currentTextEditingValue.selection.start,
              editableTextState.currentTextEditingValue.selection.end,
            );
            var controller = SearchCustomController();
            await controller.changeSettings(KeywordSearchSettings(
              basmala: false,
              keyword: selected,
              chapterID: null,
            ));
            appNavigator.pushWidget(view: SearchPage(controller: controller));
          },
          child: Container(
            child: SizedBox(
              child: Text('بحث في القرآن'),
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
        VerticalDivider(),
        InkWell(
          onTap: () async {
            var selected =
                editableTextState.currentTextEditingValue.text.substring(
              editableTextState.currentTextEditingValue.selection.start,
              editableTextState.currentTextEditingValue.selection.end,
            );
            var controller = SearchCustomController();
            await controller.changeSettings(KeywordSearchSettings(
              basmala: false,
              keyword: selected,
              chapterID: chapterId,
            ));
            appNavigator.pushWidget(view: SearchPage(controller: controller));
          },
          child: Container(
            child: SizedBox(
              child: Text('بحث في السورة'),
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      ],
    );
  }
}
