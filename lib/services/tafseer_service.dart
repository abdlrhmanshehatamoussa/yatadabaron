import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart';
import 'package:yatadabaron/commons/file_helper.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'interfaces/i_tafseer_service.dart';

class TafseerService implements ITafseerService {
  TafseerService({
    required this.analyticsService,
    required this.tafseerURL,
  });

  final String tafseerURL;
  final IAnalyticsService analyticsService;

  Uri _getRemoteUri(int tafseerSourceId) {
    String fileName = "$tafseerSourceId.zip";
    String remoteFileURL = "$tafseerURL/$fileName";
    Uri uri = Uri.parse(remoteFileURL);
    return uri;
  }

  String _getFileName(int chapterId, int verseId, int tafseerId) {
    return "$tafseerId.$chapterId.$verseId";
  }

  Future<void> _logError(String functionName, String error) async {
    await analyticsService.logError(
      error: "$functionName: $error",
      location: "TAFSEER SERVICE",
    );
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
      Uri uri = _getRemoteUri(tafseerId);
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
    } catch (e) {
      await _logError("syncTafseer", e.toString());
      return false;
    }
  }

  @override
  Future<int> getTafseerSizeMB(int tafseerSourceID) async {
    Uri uri = _getRemoteUri(tafseerSourceID);
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
}
