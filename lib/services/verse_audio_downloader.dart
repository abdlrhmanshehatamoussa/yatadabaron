import 'dart:io';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:path/path.dart';

class VerseAudioDownloader extends IVerseAudioDownloader {
  final String applicationDirectory;
  VerseAudioDownloader(this.applicationDirectory);

  @override
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  ) async {
    var file =
        _getAudioFile(verseId, chapterId, reciterKey, applicationDirectory);
    if (await file.exists()) {
      return file.path;
    } else {
      var remoteUrl = _getAudioUrl(verseId, chapterId, reciterKey);
      final Response response = await get(Uri.parse(remoteUrl));
      if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
      }
      return file.path;
    }
  }
}

class VerseAudioDownloaderWeb extends IVerseAudioDownloader {
  @override
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  ) async {
    return _getAudioUrl(verseId, chapterId, reciterKey);
  }
}

String _getAudioUrl(int verseId, int chapterId, String reciterName) {
  var verseIndex = verseId.toString().padLeft(3, '0');
  var chapterIndex = chapterId.toString().padLeft(3, '0');
  var audioUrl =
      "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3";
  return audioUrl;
}

File _getAudioFile(
  int verseId,
  int chapterId,
  String reciterKey,
  String parentDirectory,
) {
  var fileName = join(
    parentDirectory,
    "audio",
    reciterKey,
    "$chapterId$verseId.mp3",
  );
  return File(fileName);
}
