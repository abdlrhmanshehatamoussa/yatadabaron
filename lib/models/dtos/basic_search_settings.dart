class BasicSearchSettings {
  final int? chapterId;

  BasicSearchSettings({
    this.chapterId,
  });

  bool get wholeQuran => (chapterId == null);

  BasicSearchSettings updateChapterId(int? id) {
    return BasicSearchSettings(
      chapterId: id,
    );
  }
}
