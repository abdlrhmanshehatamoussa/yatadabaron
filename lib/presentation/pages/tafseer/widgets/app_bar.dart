import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import '../bloc.dart';

class TafseerAppBar{
  static AppBar build(BuildContext context) {
    TafseerPageBloc bloc = Provider.of(context);
    return AppBar(
      title: Text(Localization.TAFSEER_PAGE),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: ButtonBar(
          children: [
            IconButton(
              onPressed: () async => await bloc.onSaveBookmarkClicked(context),
              icon: Icon(Icons.bookmark),
            ),
            IconButton(
              onPressed: () async => await bloc.shareVerse(),
              icon: Icon(Icons.share),
            )
          ],
        ),
      ),
    );
  }
}
