import 'package:yatadabaron/presentation/modules/views.module.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:flutter/material.dart';

class MushafController {
  MushafController(int? chapterId, int? verseId) {
    reloadVerses(chapterId, verseId);
  }

  CustomStreamController<List<Verse>> _versesBloc = CustomStreamController();
  CustomStreamController<Chapter> _selectedChapterBloc =
      CustomStreamController();

  Stream<Chapter> get selectedChapterStream =>
      _selectedChapterBloc.stream;
  Stream<List<Verse>> get versesStream => _versesBloc.stream;

  Future reloadVerses(int? chapterId, int? verseId) async {
    chapterId = chapterId ?? 1;
    Chapter chapter = await ServiceManager.instance.mushafService
        .getChapter(chapterId);
    List<Verse> verses = await ServiceManager.instance.mushafService
        .getVersesByChapterId(chapterId, false);

    _selectedChapterBloc.add(chapter);
    if (verseId != null && verseId > 0) {
      verses.firstWhere((v) => v.verseID == verseId).isSelected = true;
    }
    //Load the bookmarks
    int? bmC =
        await ServiceManager.instance.userDataService.getBookmarkChapter();
    if (bmC != null) {
      if (bmC == chapterId) {
        int? bmV =
            await ServiceManager.instance.userDataService.getBookmarkVerse();
        verses.firstWhere((v) => v.verseID == bmV).isBookmark = true;
      }
    }
    _versesBloc.add(verses);
  }

  Future<List<Chapter>> get getChaptersSimple async {
    return await ServiceManager.instance.mushafService.getAll(includeWholeQuran:false);
  }

  Future<void> logChapterSelected(String chatperNameAR, int chapterID) async {
    ServiceManager.instance.analyticsService.logOnTap(
      "CHAPTER SELECTED",
      payload: "NAME=$chatperNameAR|ID=$chapterID",
    );
  }

  Future<void> onVerseTap(Verse result, BuildContext context) async {
    if (result.verseID != null && result.chapterId != null) {
      TafseerPage.push(
        context: context,
        verseId: result.verseID!,
        chapterId: result.chapterId!,
        onBookmarkSaved: () {
          reloadVerses(result.chapterId, result.verseID);
        },
      );
    }
  }
}
