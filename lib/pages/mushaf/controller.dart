import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:simply/simply.dart';
import 'view_models/mushaf_state.dart';
import '../_viewmodels/module.dart';

class MushafController {
  MushafController();

  late IChaptersService chaptersService = Simply.get<IChaptersService>();
  late IVersesService versesService = Simply.get<IVersesService>();
  late IBookmarksService bookmarksService = Simply.get<IBookmarksService>();

  Future<MushafPageState> reloadVerses(MushafSettings? mushafSettings) async {
    if (mushafSettings == null) {
      Bookmark? lastBookmark = await bookmarksService.getLastBookmark();
      if (lastBookmark != null) {
        mushafSettings = MushafSettings.fromBookmark(
          chapterId: lastBookmark.chapterId,
          verseId: lastBookmark.verseId,
        );
      }

      if (mushafSettings == null) {
        mushafSettings = MushafSettings.fromSelection(
          chapterId: 1,
          verseId: 1,
        );
      }
    }
    int chapterId = mushafSettings.chapterId;
    int verseId = mushafSettings.verseId;
    Chapter chapter = await chaptersService.getChapter(chapterId);
    List<Verse> verses =
        await versesService.getVersesByChapterId(chapterId, false);
    List<Chapter> chapters = await chaptersService.getAll();
    MushafPageState state = MushafPageState(
      chapter: chapter,
      verses: verses,
      startFromVerse: verseId,
      mode: mushafSettings.mode,
      chapters: chapters,
    );
    return state;
  }

  void goTafseerPage(Verse verse) {
    appNavigator.pushWidget(
      view: TafseerPage(
        location: MushafLocation(
          verseId: verse.verseID,
          chapterId: verse.chapterId,
        ),
      ),
    );
  }

  Future<void> shareVerses(List<Verse> verses) async {
    if (verses.isEmpty) {
      return;
    }
    List<String> lines = [];
    for (var verse in verses) {
      verse =
          await versesService.getSingleVerse(verse.verseID, verse.chapterId);
      String line = "${verse.verseTextTashkel} {${verse.verseID}}";
      lines.add(line);
    }
    var toShare = "${verses[0].chapterName}\n" + lines.join("\n");
    await Share.share(toShare);
  }
}
