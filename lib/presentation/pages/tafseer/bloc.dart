import 'package:yatadabaron/application/service-manager.dart';
import 'package:yatadabaron/domain/dtos/verse-dto.dart';
import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/shared-blocs.module.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class TafseerPageBloc {
  TafseerPageBloc(this._verse, this._onBookmarkSaved) {
    _initialize();
  }

  final VerseDTO _verse;
  final Function _onBookmarkSaved;
  final CustomStreamController<TafseerResultDTO> _tafseerResultController =
      CustomStreamController<TafseerResultDTO>();
  Stream<TafseerResultDTO> get tafseerStream => _tafseerResultController.stream;

  Future<void> _initialize() async {
    List<TafseerDTO> tafseers = await getAvailableTafseers();
    if (tafseers.isNotEmpty) {
      await updateTafseerStream(tafseers.first.tafseerId);
    }
  }

  Future<void> shareVerse() async {
    String toCopy =
        "${_verse.chapterName}\n${_verse.verseTextTashkel} {${_verse.verseID}}";
    await Share.share(toCopy);
  }

  Future<List<TafseerDTO>> getAvailableTafseers() async {
    return await ServiceManager.instance.mushafService.getAvailableTafseers();
  }

  Future<void> updateTafseerStream(int tafseerId) async {
    if (_verse.verseID != null && _verse.chapterId != null) {
      TafseerResultDTO result =
          await ServiceManager.instance.mushafService.getTafseer(
        tafseerId,
        _verse.verseID!,
        _verse.chapterId!,
      );
      _tafseerResultController.add(result);
    }
  }

  Future<void> onSaveBookmarkClicked(BuildContext context) async {
    int chapterId = _verse.chapterId!;
    int verseId = _verse.verseID!;
    await ServiceManager.instance.userDataService.setBookmarkChapter(chapterId);
    await ServiceManager.instance.userDataService.setBookmarkVerse(verseId);
    await _onBookmarkSaved();
    await Utils.showCustomDialog(
      context: context,
      title: Localization.BOOKMARK_SAVED,
    );
    Navigator.of(context).pop();
  }
}
