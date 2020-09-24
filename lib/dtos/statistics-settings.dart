class StatisticsSettings{
  int chapterId;
  bool basmala;

  StatisticsSettings(this.chapterId, this.basmala);

  static StatisticsSettings empty(){
    return StatisticsSettings(0, false);
  }
}