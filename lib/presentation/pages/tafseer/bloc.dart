import 'package:Yatadabaron/domain/dtos/verse-dto.dart';
import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/presentation/modules/shared-blocs.module.dart';
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
    //TODO
    return [
      TafseerDTO(tafseerId: 1, tafseerName: "ابن كثير"),
      TafseerDTO(tafseerId: 2, tafseerName: "الطبري"),
    ];
  }

  Future<void> updateTafseerStream(int tafseerId) async {
    //TODO:
    if (tafseerId == 1) {
      _tafseerResultController.add(
        TafseerResultDTO(
            verseId: _verse.verseID!,
            chapterId: _verse.chapterId!,
            tafseerId: tafseerId,
            tafseerName: "ابن كثير",
            chapterName: "تجريبي",
            tafseer: " تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير تجريبي تفسير ابن كثير",
            verseTextTashkeel: _verse.verseTextTashkel!),
      );
    } else {
      _tafseerResultController.add(
        TafseerResultDTO(
            verseId: _verse.verseID!,
            chapterId: _verse.chapterId!,
            tafseerId: tafseerId,
            tafseerName: "الطبري",
            chapterName: "تجريبي",
            tafseer: " تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري تجريبي تفسير الطبري",
            verseTextTashkeel: _verse.verseTextTashkel!),
      );
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
