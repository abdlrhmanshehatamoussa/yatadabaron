import 'package:http/http.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/global.dart';

class AudioVerseService implements IAudioVerseService {
  final IAudioVerseCacheManager audioVerseCacheManager;

  AudioVerseService(
    this.audioVerseCacheManager,
  );

  @override
  Future<List<String>> getAudioUrlsOrPath(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  ) async {
    var result = <String>[];
    for (var i = start; i <= end; i++) {
      var verseId3Digits = i.toString().padLeft(3, '0');
      var chapterId3Digits = chapterId.toString().padLeft(3, '0');
      var audioVerseUrl =
          "https://everyayah.com/data/$reciterKey/$chapterId3Digits$verseId3Digits.mp3";
      String? audioVerseFilePath = await audioVerseCacheManager
          .getAudioVerseFilePathOrCache(audioVerseUrl);
      result.add(audioVerseFilePath ?? audioVerseUrl);
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
