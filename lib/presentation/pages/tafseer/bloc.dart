import 'package:yatadabaron/application/service-manager.dart';
import 'package:yatadabaron/domain/dtos/verse-dto.dart';
import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class TafseerPageBloc {
  TafseerPageBloc(this._verseId, this._chapterId, this._onBookmarkSaved);

  final int _verseId;
  final int _chapterId;
  final Function _onBookmarkSaved;
  final CustomStreamController<VerseTafseer> _tafseerResultController =
      CustomStreamController<VerseTafseer>();

  Stream<VerseTafseer> get tafseerStream => _tafseerResultController.stream;

  Future<VerseDTO> loadVerseDTO() async {
    return await ServiceManager.instance.mushafService
        .getSingleVerse(_verseId, _chapterId);
  }

  Future<void> shareVerse() async {
    VerseDTO _verse = await loadVerseDTO();
    String toCopy =
        "${_verse.chapterName}\n${_verse.verseTextTashkel} {${_verse.verseID}}";
    await Share.share(toCopy);
  }

  Future<List<TafseerSource>> getAvailableTafseers() async {
    var tafseers =
        await ServiceManager.instance.tafseerService.getTafseerSources();
    if (tafseers.isNotEmpty) {
      await updateTafseerStream(tafseers.first.tafseerId);
    }
    return tafseers;
  }

  Future<void> updateTafseerStream(int tafseerId) async {
    VerseTafseer result = await ServiceManager.instance.tafseerService
        .getTafseer(tafseerId, _verseId, _chapterId);
    _tafseerResultController.add(result);
  }

  Future<void> onSaveBookmarkClicked(BuildContext context) async {
    await ServiceManager.instance.userDataService
        .setBookmarkChapter(this._chapterId);
    await ServiceManager.instance.userDataService
        .setBookmarkVerse(this._verseId);
    await _onBookmarkSaved();
    await Utils.showCustomDialog(
      context: context,
      title: Localization.BOOKMARK_SAVED,
    );
    Navigator.of(context).pop();
  }

  Future<void> downloadTafseerSource(
      int tafseerSourceID, BuildContext context) async {
    bool done = false;
    Utils.showPleaseWaitDialog(
        context: context,
        text: Localization.DOWNLOADING,
        title: Localization.PLEASE_WAIT);
    try {
      done = await ServiceManager.instance.tafseerService
          .syncTafseer(tafseerSourceID);
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
          text: Localization.DOWNLOAD_ERROR,
          title: Localization.ERROR);
    }
  }

  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    try {
      return await ServiceManager.instance.tafseerService
          .getTafseerSizeMB(tafseerSourceID);
    } catch (e) {
      return 0;
    }
  }
}
