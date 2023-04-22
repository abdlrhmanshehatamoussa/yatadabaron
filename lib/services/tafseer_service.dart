import 'dart:async';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/file_helper.dart';
import 'package:yatadabaron/main.dart';

class TafseerService implements ITafseerService {
  TafseerService({
    required this.tafseerURL,
    required this.networkDetectorService,
  });

  final String tafseerURL;
  final INetworkDetectorService networkDetectorService;

  Uri _getRemoteUri(int tafseerSourceId) {
    String fileName = "$tafseerSourceId.zip";
    String remoteFileURL = "$tafseerURL/raw/main/$fileName";
    Uri uri = Uri.parse(remoteFileURL);
    return uri;
  }

  String _getFileName(int chapterId, int verseId, int tafseerId) {
    return join(
        "tafseer", tafseerId.toString(), "$tafseerId.$chapterId.$verseId");
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
      final Response response = await get(uri);
      if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
        final Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);
        var outputDirectory = join(
            (await getApplicationDocumentsDirectory()).path,
            "tafseer",
            tafseerId.toString());
        extractArchiveToDisk(archive, outputDirectory);
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
