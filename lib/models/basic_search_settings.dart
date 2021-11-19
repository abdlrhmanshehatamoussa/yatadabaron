class BasicSearchSettings {
  final int chapterId;
  final bool basmala;
  final bool searchWholeQuran;

  BasicSearchSettings({
    required this.chapterId,
    required this.basmala,
    required this.searchWholeQuran,
  });

  static BasicSearchSettings empty() {
    return BasicSearchSettings(
      chapterId: 1,
      basmala: false,
      searchWholeQuran: true,
    );
  }

  BasicSearchSettings copyWithChapterId(int id) {
    return BasicSearchSettings(
      chapterId: id,
      basmala: basmala,
      searchWholeQuran: searchWholeQuran,
    );
  }

  BasicSearchSettings copyWithWholeQuran(bool newSearchWholeQuran) {
    return BasicSearchSettings(
      chapterId: chapterId,
      basmala: basmala,
      searchWholeQuran: newSearchWholeQuran,
    );
  }

  BasicSearchSettings copyWithBasmala(bool newBasmala) {
    return BasicSearchSettings(
      chapterId: chapterId,
      basmala: newBasmala,
      searchWholeQuran: searchWholeQuran,
    );
  }
}
