import 'dart:async';
import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/extensions.dart';
import 'package:yatadabaron/commons/file_helper.dart';
import 'package:simply/simply.dart';

class TafseerService implements ITafseerService, ISimpleService {
  TafseerService({
    required this.tafseerURL,
    required this.networkDetectorService,
  });

  final String tafseerURL;
  final INetworkDetectorService networkDetectorService;

  Uri _getRemoteUri(int tafseerSourceId) {
    String fileName = "$tafseerSourceId.zip";
    String remoteFileURL = "$tafseerURL/$fileName";
    Uri uri = Uri.parse(remoteFileURL);
    return uri;
  }

  String _getFileName(int chapterId, int verseId, int tafseerId) {
    return "$tafseerId.$chapterId.$verseId";
  }

  @override
  Future<VerseTafseer> getTafseer(
    int tafseerId,
    int verseId,
    int chapterId,
  ) async {
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
  Future<bool> syncTafseer(int tafseerId) async {
    try {
      var online = await networkDetectorService.isOnline();
      if (online == false) return false;
      Uri uri = _getRemoteUri(tafseerId);
      final Response response = await get(uri).defaultNetworkTimeout();
      if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
        final Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);
        for (ArchiveFile archiveFile in archive) {
          File diskFile = await FileHelper.create(archiveFile.name);
          await diskFile.writeAsBytes(archiveFile.content);
        }
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    try {
      var online = await networkDetectorService.isOnline();
      if (online == false) return -1;
      Uri uri = _getRemoteUri(tafseerSourceID);
      final Response response = await head(uri).defaultNetworkTimeout();
      String? sizeBytesStr = response.headers["content-length"];
      double? sizeBytes = double.tryParse(sizeBytesStr ?? "");
      if (sizeBytes != null) {
        double sizeMB = sizeBytes / 1000000;
        return sizeMB.round();
      }
    } catch (e) {
      print(e);
    }
    return -1;
  }
}
