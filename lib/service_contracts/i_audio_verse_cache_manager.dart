abstract class IAudioVerseCacheManager {
  Future<String?> getAudioVerseFilePathOrCache(String url);
  void stopPendingDownloads();
}
