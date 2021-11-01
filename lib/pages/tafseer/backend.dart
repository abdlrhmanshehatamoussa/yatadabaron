import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/backend.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class TafseerPageBackend implements ISimpleBackend {
  TafseerPageBackend({
    required this.location,
    required this.tafseerService,
    required this.userDataService,
    required this.versesService,
    required this.analyticsService,
    required this.tafseerSourcesService,
  });

  final MushafLocation location;
  final IVersesService versesService;
  final IAnalyticsService analyticsService;
  final ITafseerService tafseerService;
  final ITafseerSourcesService tafseerSourcesService;
  final IUserDataService userDataService;
  final StreamObject<VerseTafseer> _tafseerResultController =
      StreamObject<VerseTafseer>();

  Stream<VerseTafseer> get tafseerStream => _tafseerResultController.stream;

  Future<Verse> loadVerseDTO() async {
    return await versesService.getSingleVerse(
        this.location.verseId, this.location.chapterId);
  }

  Future<void> shareVerse() async {
    Verse _verse = await loadVerseDTO();
    String toCopy =
        "${_verse.chapterName}\n${_verse.verseTextTashkel} {${_verse.verseID}}";
    await Share.share(toCopy);
  }

  Future<List<TafseerSource>> getAvailableTafseers() async {
    var tafseers = await tafseerSourcesService.getTafseerSources();
    if (tafseers.isNotEmpty) {
      await updateTafseerStream(tafseers.first.tafseerId);
    }
    return tafseers;
  }

  Future<void> updateTafseerStream(int tafseerId) async {
    VerseTafseer result = await tafseerService.getTafseer(
        tafseerId, this.location.verseId, this.location.chapterId);
    _tafseerResultController.add(result);
    await analyticsService.logOnTap(
      "TAFSEER PAGE",
      payload: "SELECTED TAFSEER=$tafseerId",
    );
  }

  Future<bool> onSaveBookmarkClicked(BuildContext context) async {
    bool done = await userDataService.addMushafLocation(this.location);
    return done;
  }

  Future<void> downloadTafseerSource(
    int tafseerSourceID,
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
      await updateTafseerStream(tafseerSourceID);
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
