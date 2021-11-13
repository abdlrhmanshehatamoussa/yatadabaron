import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class TafseerPageBackend extends SimpleBackend {
  TafseerPageBackend({
    required this.location,
    required BuildContext context,
  }) : super(context);

  final MushafLocation location;
  final StreamObject<VerseTafseer> _tafseerResultController =
      StreamObject<VerseTafseer>();
  late IVersesService versesService = getService<IVersesService>();
  late IAnalyticsService analyticsService = getService<IAnalyticsService>();
  late ITafseerService tafseerService = getService<ITafseerService>();
  late ITafseerSourcesService tafseerSourcesService =
      getService<ITafseerSourcesService>();
  late IBookmarksService bookmarksService = getService<IBookmarksService>();

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
    bool done = await bookmarksService.addBookmark(
      this.location.chapterId,
      this.location.verseId,
    );
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