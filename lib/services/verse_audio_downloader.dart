import 'dart:io';
import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:path/path.dart';
import 'package:yatadabaron/global.dart';

class VerseAudioDownloader extends VerseAudioDownloaderWeb {
  final String applicationDirectory;
  VerseAudioDownloader(this.applicationDirectory);

  @override
  Future<List<String>> getAudioUrlsOrPath(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  ) async {
    var remoteUrls = await super.getAudioUrlsOrPath(
      chapterId,
      start,
      end,
      reciterKey,
    );
    var result = <String>[];
    var j = 0;
    for (var i = start; i <= end; i++) {
      var fileName = join(
        applicationDirectory,
        "audio",
        reciterKey,
        "$chapterId.$i.mp3",
      );
      var file = File(fileName);
      if (await file.exists() == false) {
        final Response response = await get(Uri.parse(remoteUrls[j]));
        if ((response.contentLength ?? 0) > 0 &&
            response.bodyBytes.isNotEmpty) {
          await file.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes);
        }
      }
      result.add(file.path);
      j += 1;
    }
    return result;
  }
}

class VerseAudioDownloaderWeb extends IVerseAudioDownloader {
  @override
  Future<List<String>> getAudioUrlsOrPath(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  ) async {
    var result = <String>[];
    for (var i = start; i <= end; i++) {
      var verseIndex = i.toString().padLeft(3, '0');
      var chapterIndex = chapterId.toString().padLeft(3, '0');
      var audioUrl =
          "https://everyayah.com/data/$reciterKey/$chapterIndex$verseIndex.mp3";
      result.add(audioUrl);
    }
    return result;
  }

  @override
  Future<double> getSizeMb(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  ) async {
    var urls = await getAudioUrlsOrPath(chapterId, start, end, reciterKey);
    double totalBytes = 0;
    for (var i = 0; i < urls.length; i++) {
      Uri uri = Uri.parse(urls[i]);
      final Response response = await head(uri).defaultNetworkTimeout();
      String? sizeBytesStr = response.headers["content-length"];
      double sizeBytes = double.parse(sizeBytesStr ?? "");
      totalBytes += sizeBytes;
    }
    return totalBytes / 1000;
  }
}
