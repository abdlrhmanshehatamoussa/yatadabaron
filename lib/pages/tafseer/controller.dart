import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/controller.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class TafseerPageController implements ISimpleController {
  TafseerPageController({
    required this.tafseerService,
    required this.userDataService,
    required this.versesService,
    required this.analyticsService,
    required this.tafseerSourcesService,
  });

  final IVersesService versesService;
  final IAnalyticsService analyticsService;
  final ITafseerService tafseerService;
  final ITafseerSourcesService tafseerSourcesService;
  final IUserDataService userDataService;
  final StreamObject<VerseTafseer> _tafseerResultController =
      StreamObject<VerseTafseer>();

  Stream<VerseTafseer> get tafseerStream => _tafseerResultController.stream;

  Future<Verse> loadVerseDTO(MushafLocation loc) async {
    return await versesService.getSingleVerse(loc.verseId, loc.chapterId);
  }

  Future<void> shareVerse(MushafLocation loc) async {
    Verse _verse = await loadVerseDTO(loc);
    String toCopy =
        "${_verse.chapterName}\n${_verse.verseTextTashkel} {${_verse.verseID}}";
    await Share.share(toCopy);
  }

  Future<List<TafseerSource>> getAvailableTafseers(
      MushafLocation location) async {
    var tafseers = await tafseerSourcesService.getTafseerSources();
    if (tafseers.isNotEmpty) {
      await updateTafseerStream(location, tafseers.first.tafseerId);
    }
    return tafseers;
  }

  Future<void> updateTafseerStream(MushafLocation loc, int tafseerId) async {
    VerseTafseer result =
        await tafseerService.getTafseer(tafseerId, loc.verseId, loc.chapterId);
    _tafseerResultController.add(result);
    await analyticsService.logOnTap(
      "TAFSEER PAGE",
      payload: "SELECTED TAFSEER=$tafseerId",
    );
  }

  Future<bool> onSaveBookmarkClicked(
    BuildContext context,
    MushafLocation loc,
  ) async {
    bool done = await userDataService.addMushafLocation(loc);
    return done;
  }

  Future<void> downloadTafseerSource(
    int tafseerSourceID,
    MushafLocation location,
    BuildContext context,
  ) async {
    bool done = false;
    Utils.showPleaseWaitDialog(
        context: context,
        text: Localization.DOWNLOADING,
        title: Localization.PLEASE_WAIT);
    try {
      done = await tafseerService.syncTafseer(tafseerSourceID);
    } catch (e) {
      done = false;
    }
    if (done) {
      await updateTafseerStream(location, tafseerSourceID);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      await Utils.showCustomDialog(
        context: context,
        text: Localization.NO_TRANSLATIONS_AVAILABLE,
        title: Localization.ERROR,
      );
    }
    await analyticsService.logOnTap(
      "TAFSEER PAGE",
      payload:
          "TAFSEER SOURCE ID=$tafseerSourceID|TAFSEER DOWNLOAD STATUS=$done",
    );
  }

  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    try {
      return await tafseerService.getTafseerSizeMB(tafseerSourceID);
    } catch (e) {
      return 0;
    }
  }
}
