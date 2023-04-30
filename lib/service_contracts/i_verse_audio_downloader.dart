abstract class IVerseAudioDownloader {
  Future<String> getAudioUrlOrPath(
    int verseId,
    int chapterId,
    String reciterKey,
  );
  Future<double> getSizeMb(
    int verseId,
    int chapterId,
    String reciterKey,
  );
}
