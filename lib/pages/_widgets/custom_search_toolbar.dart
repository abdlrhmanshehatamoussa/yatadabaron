import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';

import '../search/controller.dart';
import '../search/view.dart';

class CustomSerachToolbar extends StatelessWidget {
  final EditableTextState editableTextState;

  const CustomSerachToolbar({
    Key? key,
    required this.editableTextState,
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
            var controller = SearchController();
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
        )
      ],
    );
  }
}
