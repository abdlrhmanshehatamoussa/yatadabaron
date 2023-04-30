import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/tarteel/page.dart';
import 'playable_item.dart';

class TarteelSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TarteelSelectionPage> with _Controller {
  var chapterId = 2;
  var start = 1;
  var end = 2;
  var reciterName = "Saood_ash-Shuraym_128kbps";
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ترتيل")),
      body: Column(
        children: [
          DropdownButton<int>(items: [], onChanged: (v) {}),
          TextFormField(),
          TextFormField(),
          IconButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await onClickTarteel(chapterId, start, end, reciterName);
                    } catch (e) {
                      Utils.showInternetConnectionErrorDialog(context);
                    }
                    setState(() {
                      loading = false;
                    });
                  },
            icon: Icon(Icons.play_circle, size: 50),
          )
        ],
      ),
    );
  }
}

class _Controller {
  final verseService = Simply.get<IVersesService>();
  final chapterService = Simply.get<IChaptersService>();
  final audioDownloaderService = Simply.get<IVerseAudioDownloader>();

  Future<void> onClickTarteel(
    int chapterId,
    int start,
    int end,
    String reciterName,
  ) async {
    var result = <TarteelPlayableItem>[];
    var chapterName =
        (await chapterService.getChapter(chapterId)).chapterNameAR;
    var verses = await verseService.getVersesByChapterId(chapterId, false);
    verses = verses
        .where((element) => element.verseID >= start && element.verseID <= end)
        .toList();
    for (var i = 0; i < verses.length; i++) {
      var verse = verses[i];
      var audioUrl = await audioDownloaderService.getAudioUrlOrPath(
        verse.verseID,
        chapterId,
        reciterName,
      );
      result.add(
        TarteelPlayableItem(
          order: i,
          verseText: verse.verseTextTashkelWithNumber,
          verseId: verse.verseID,
          chapterName: chapterName,
          audioUrl: audioUrl,
        ),
      );
    }

    appNavigator.pushWidget(
      view: TarteelPage(
        playableItems: result,
        reciterName: "سعود الشريم",
      ),
    );
  }
}
