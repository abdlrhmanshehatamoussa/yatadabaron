import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';

class TafseerAppBar {
  static AppBar build({
    required BuildContext context,
    required Function onShare,
    required Function onSaveBookmark,
  }) {
    return AppBar(
      title: Text(Localization.TAFSEER_PAGE),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: ButtonBar(
          children: [
            IconButton(
              onPressed: () => onSaveBookmark(),
              icon: Icon(Icons.bookmark_add_sharp),
            ),
            IconButton(
              onPressed: () => onShare(),
              icon: Icon(Icons.share),
            )
          ],
        ),
      ),
    );
  }
}
