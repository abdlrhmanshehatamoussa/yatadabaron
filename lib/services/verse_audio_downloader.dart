import 'dart:io';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:path/path.dart';
import 'package:yatadabaron/global.dart';

class VerseAudioDownloader extends VerseAudioDownloaderWeb {
  final String applicationDirectory;
  VerseAudioDownloader(this.applicationDirectory);

  @override
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  ) async {
    var file = _getAudioFile(
      verseId,
      chapterId,
      reciterKey,
      applicationDirectory,
    );
    if (await file.exists()) {
      return file.path;
    }
    var remoteUrl = await super.getAudioUrlOrPath(
      verseId,
      chapterId,
      reciterKey,
    );
    final Response response = await get(Uri.parse(remoteUrl));
    if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
      await file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
    }
    return file.path;
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
}

class VerseAudioDownloaderWeb extends IVerseAudioDownloader {
  @override
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  ) async {
    return _getAudioRemoteUrl(verseId, chapterId, reciterKey);
  }

  @override
  Future<double> getSizeMb(
    int verseId,
    int chapterId,
    String reciterKey,
  ) async {
    var url = _getAudioRemoteUrl(verseId, chapterId, reciterKey);
    Uri uri = Uri.parse(url);
    final Response response = await head(uri).defaultNetworkTimeout();
    String? sizeBytesStr = response.headers["content-length"];
    double sizeMB = double.parse(sizeBytesStr ?? "") / 1000000;
    return sizeMB;
  }

  String _getAudioRemoteUrl(int verseId, int chapterId, String reciterKey) {
    var verseIndex = verseId.toString().padLeft(3, '0');
    var chapterIndex = chapterId.toString().padLeft(3, '0');
    var audioUrl =
        "https://everyayah.com/data/$reciterKey/$chapterIndex$verseIndex.mp3";
    return audioUrl;
  }
}
