abstract class IAudioVerseService {
  Future<List<String>> getAudioUrlsOrPath(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  );
  Future<double> getSizeMb(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  );
}
