import 'package:share/share.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
import 'package:simply/simply.dart';
import 'view_models/mushaf_state.dart';
import '../_viewmodels/module.dart';

class MushafController {
  MushafController({
    required this.mushafSettings,
  }) {
    reloadVerses(mushafSettings);
  }

  final MushafSettings? mushafSettings;
  late IChaptersService chaptersService = Simply.get<IChaptersService>();
  late IVersesService versesService = Simply.get<IVersesService>();
  late IBookmarksService bookmarksService = Simply.get<IBookmarksService>();

  StreamObject<MushafPageState> _stateStreamObj = StreamObject();
  Stream<MushafPageState> get stateStream => _stateStreamObj.stream;

  Future reloadVerses(MushafSettings? mushafSettings) async {
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
    _stateStreamObj.add(state);
  }

  Future<void> onChapterSelected(Chapter chapter) async {
    await reloadVerses(
      MushafSettings.fromSelection(
        chapterId: chapter.chapterID,
        verseId: 1,
      ),
    );
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

  Future<void> shareVerse(Verse verse) async {
    verse = await versesService.getSingleVerse(verse.verseID, verse.chapterId);
    String toCopy =
        "${verse.chapterName}\n${verse.verseTextTashkel} {${verse.verseID}}";
    await Share.share(toCopy);
  }
}
