import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:yatadabaron/service_contracts/i_audio_verse_cache_manager.dart';

class AudioVerseCacheManager implements IAudioVerseCacheManager {
  static Queue<String> _queue = Queue<String>();

  final String applicationDirectory;
  StreamSubscription? subscription;

  AudioVerseCacheManager(this.applicationDirectory) {
    subscription =
        Stream.periodic(Duration(seconds: 5), (x) => x).listen((event) async {
      if (_queue.isNotEmpty) {
        subscription?.pause();
        var audioUrl = _queue.removeFirst();
        await _download(audioUrl);
        subscription?.resume();
      }
    });
  }

  @override
  Future<String?> getAudioVerseFilePathOrCache(
    String audioUrl,
  ) async {
    var filePath = _getFilePath(audioUrl);
    if (await File(filePath).exists()) {
      return filePath;
    } else {
      _queue.addLast(audioUrl);
      subscription?.resume();
      return null;
    }
  }

  @override
  void stopPendingDownloads() {
    subscription?.pause();
    _queue.clear();
  }

  Future<void> _download(String audioUrl) async {
    var fileName = _getFilePath(audioUrl);
    var file = File(fileName);
    if (await file.exists() == false) {
      final Response response = await get(Uri.parse(audioUrl));
      if ((response.contentLength ?? 0) > 0 && response.bodyBytes.isNotEmpty) {
        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
      }
    }
  }

  String _getFilePath(String audioUrl) {
    var encodedUrl = base64Encode(utf8.encode(audioUrl));
    return join(applicationDirectory, "audio", "$encodedUrl.mp3");
  }
}

class AudioVerseCacheManagerWeb implements IAudioVerseCacheManager {
  @override
  Future<String?> getAudioVerseFilePathOrCache(String audioUrl) async {
    return null;
  }

  @override
  void stopPendingDownloads() {
    return;
  }
}
