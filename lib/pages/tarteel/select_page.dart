import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/tarteel/page.dart';

import 'playable_item.dart';

class TarteelSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ترتيل")),
      body: Column(
        children: [
          IconButton(
            onPressed: () async {
              var chapterId = 2;
              var start = 190;
              var end = 230;
              var reciterName = "Saood_ash-Shuraym_128kbps";
              var result = <TarteelPlayableItem>[];
              var service = Simply.get<IVersesService>();
              var chapterService = Simply.get<IChaptersService>();
              var chapterName =
                  (await chapterService.getChapter(chapterId)).chapterNameAR;
              var verses = await service.getVersesByChapterId(chapterId, false);
              verses = verses
                  .where((element) =>
                      element.verseID >= start && element.verseID <= end)
                  .toList();
              for (var i = 0; i < verses.length; i++) {
                var verse = verses[i];
                var verseIndex = verse.verseID.toString().padLeft(3, '0');
                var chapterIndex = chapterId.toString().padLeft(3, '0');
                result.add(
                  TarteelPlayableItem(
                    order: i,
                    verseText: verse.verseTextTashkel +
                        " " +
                        ArabicNumbers().convert(verse.verseID.toString()),
                    verseId: verse.verseID,
                    chapterName: chapterName,
                    audioUrl:
                        "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3",
                    imageUrl:
                        "https://everyayah.com/data/images_png/${chapterId}_${verse.verseID}.png",
                  ),
                );
              }

              appNavigator.pushWidget(
                  view: TarteelPage(
                playableItems: result,
              ));
            },
            icon: Text("ترتيل"),
          )
        ],
      ),
    );
  }
}
