import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:simply/simply.dart';
import '../_viewmodels/module.dart';

class TafseerPageController {
  TafseerPageController({
    required this.location,
  });

  final MushafLocation location;
  final StreamObject<VerseTafseer> _tafseerResultController =
      StreamObject<VerseTafseer>();
  late IVersesService versesService = Simply.get<IVersesService>();
  late ITafseerService tafseerService = Simply.get<ITafseerService>();
  late ITafseerSourcesService tafseerSourcesService =
      Simply.get<ITafseerSourcesService>();
  late IBookmarksService bookmarksService = Simply.get<IBookmarksService>();
  late IEventLogger eventLogger = Simply.get<IEventLogger>();

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
  }

  Future<bool> onSaveBookmarkClicked() async {
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
    await eventLogger.logTapEvent(
      description: "download_tafseer",
      payload: {
        "tafseer_source_id": tafseerSourceID,
        "tafseer_download_status": done
      },
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
