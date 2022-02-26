class BasicSearchSettings {
  final int? chapterId;
  final bool basmala;

  BasicSearchSettings({
    this.chapterId,
    this.basmala = false,
  });

  bool get wholeQuran => (chapterId == null);

  BasicSearchSettings updateChapterId(int? id) {
    return BasicSearchSettings(
      chapterId: id,
      basmala: basmala,
    );
  }

  BasicSearchSettings updateBasmala(bool newBasmala) {
    return BasicSearchSettings(
      chapterId: chapterId,
      basmala: newBasmala,
    );
  }
}
