abstract class IVerseAudioDownloader {
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  );
}
