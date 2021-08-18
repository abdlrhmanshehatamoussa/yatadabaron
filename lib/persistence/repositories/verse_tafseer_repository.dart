import 'dart:io';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';

abstract class IVerseTafseerRepository {
  Future<VerseTafseer> getTafseer({
    required int chapterId,
    required int verseId,
    required int tafseerId,
  });

  Future<void> sync(int tafseerId);

  Future<bool> any(int tafseerId);
}

class VerseTafseerRepository implements IVerseTafseerRepository {
  final String remoteFileURL;

  VerseTafseerRepository({required this.remoteFileURL});

  @override
  Future<VerseTafseer> getTafseer({
    required int chapterId,
    required int verseId,
    required int tafseerId,
  }) async {
    String? tafseerText;
    String fileName = _getFileName(chapterId, verseId, tafseerId);
    File? tafseerTextFile = await FileHelper.getIfExists(fileName);
    if (tafseerTextFile != null) {
      tafseerText = await tafseerTextFile.readAsString();
    }
    VerseTafseer dto = VerseTafseer(
      verseId: verseId,
      tafseerText: tafseerText,
      tafseerSourceID: tafseerId,
    );
    return dto;
  }

  @override
  Future<void> sync(int tafseerId) {
    //TODO: implement sync (remote => local, replace)
    throw UnimplementedError();
  }

  @override
  Future<bool> any(int tafseerId) async {
    String fileName = _getFileName(1, 1, tafseerId);
    bool fileExists = await FileHelper.exists(fileName);
    return fileExists;
  }

  String get _directoryName => "tafseer";

  String _getFileName(int chapterId, int verseId, int tafseerId) {
    return "$_directoryName/$chapterId.$verseId.$tafseerId.txt";
  }
}
