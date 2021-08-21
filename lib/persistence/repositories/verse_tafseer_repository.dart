import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';

abstract class IVerseTafseerRepository {
  Future<VerseTafseer> fetch({
    required int chapterId,
    required int verseId,
    required int tafseerId,
  });

  Future<bool> sync(int tafseerId);

  Future<int> getTafseerSizeMB(int tafseerSourceID);
}

class VerseTafseerRepository implements IVerseTafseerRepository {
  final String remoteURL;

  VerseTafseerRepository({required this.remoteURL});

  @override
  Future<VerseTafseer> fetch({
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
  Future<bool> sync(int tafseerSourceId) async {
    Uri uri = _getRemoteUri(tafseerSourceId);
    final Response response = await get(uri);
    if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
      final Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);
      for (ArchiveFile archiveFile in archive) {
        File diskFile = await FileHelper.create(archiveFile.name);
        await diskFile.writeAsBytes(archiveFile.content);
      }
      return true;
    }
    return false;
  }

  @override
  Future<int> getTafseerSizeMB(int tafseerSourceId) async {
    Uri uri = _getRemoteUri(tafseerSourceId);
    final Response response = await head(uri);
    String? sizeBytesStr = response.headers["content-length"];
    double? sizeBytes = double.tryParse(sizeBytesStr ?? "");
    if (sizeBytes != null) {
      double sizeMB = sizeBytes / 1000000;
      return sizeMB.round();
    } else {
      return 0;
    }
  }

  Uri _getRemoteUri(int tafseerSourceId) {
    String fileName = "$tafseerSourceId.zip";
    String remoteFileURL = "$remoteURL/$fileName";
    Uri uri = Uri.parse(remoteFileURL);
    return uri;
  }

  String _getFileName(int chapterId, int verseId, int tafseerId) {
    return "$tafseerId.$chapterId.$verseId";
  }
}
