import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_service.dart';
import 'package:yatadabaron/services/interfaces/i_tafseer_sources_service.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';

class TafseerPageController extends BaseController {
  TafseerPageController({
    required this.tafseerService,
    required this.userDataService,
    required this.verseId,
    required this.chapterId,
    required this.versesService,
    required this.analyticsService,
    required this.tafseerSourcesService,
  });

  final int verseId;
  final int chapterId;
  final IVersesService versesService;
  final IAnalyticsService analyticsService;
  final ITafseerService tafseerService;
  final ITafseerSourcesService tafseerSourcesService;
  final IUserDataService userDataService;
  final StreamObject<VerseTafseer> _tafseerResultController =
      StreamObject<VerseTafseer>();

  Stream<VerseTafseer> get tafseerStream => _tafseerResultController.stream;

  Future<Verse> loadVerseDTO() async {
    return await versesService.getSingleVerse(verseId, chapterId);
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
    VerseTafseer result =
        await tafseerService.getTafseer(tafseerId, verseId, chapterId);
    _tafseerResultController.add(result);
    await analyticsService.logOnTap(
      "TAFSEER PAGE",
      payload: "SELECTED TAFSEER=$tafseerId",
    );
  }

  Future<void> onSaveBookmarkClicked(BuildContext context) async {
    await userDataService.setBookmarkChapter(this.chapterId);
    await userDataService.setBookmarkVerse(this.verseId);
    await Utils.showCustomDialog(
      context: context,
      title: Localization.BOOKMARK_SAVED,
    );
  }

  Future<void> downloadTafseerSource(
      int tafseerSourceID, BuildContext context) async {
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
