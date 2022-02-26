class TafseerSource {
  final int tafseerId;
  final String tafseerName;
  final String tafseerNameEnglish;

  TafseerSource({
    required this.tafseerId,
    required this.tafseerName,
    required this.tafseerNameEnglish,
  });

  static TafseerSource fromJsonRemote(json) {
    return new TafseerSource(
      tafseerId: json["tafseer_id"],
      tafseerName: json["tafseer_name"],
      tafseerNameEnglish: json["tafseer_name_en"],
    );
  }
}
