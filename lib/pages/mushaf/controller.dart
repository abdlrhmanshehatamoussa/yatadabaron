import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/commons/utils.dart';
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
  late IShareService _shareService = Simply.get<IShareService>();

  Future<MushafPageState> reloadVerses(MushafSettings? mushafSettings) async {
    if (mushafSettings == null) {
      Bookmark? lastBookmark = await bookmarksService.getLastBookmark(
          Simply.get<IMushafTypeService>().getMushafType()
      );
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

  Future<void> shareVerses(List<Verse> verses, String chapterNameAr) async {
    if (verses.isEmpty) {
      return;
    }
    for (var verse in verses) {
      verse.chapterName = chapterNameAr;
    }
    var verseIds = verses.map((v) => v.verseID).toList();
    verseIds.sort();
    bool continuous = verses.length > 1 && Utils.isListContinuous(verseIds);
    String toShare;
    if (continuous) {
      var max = verseIds.last.toArabicNumber();
      var min = verseIds.first.toArabicNumber();
      toShare = "{" +
          verses
              .map(
                  (e) => "${e.verseTextTashkel}(${e.verseID.toArabicNumber()})")
              .join("") +
          "}";
      toShare += "[$chapterNameAr $min-$max]";
    } else {
      toShare = verses.map((e) => e.toString()).join("\n");
    }

    await _shareService.share(toShare);
  }
}
