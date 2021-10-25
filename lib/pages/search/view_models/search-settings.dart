import 'package:yatadabaron/models/module.dart';

class SearchSettings{
  String keyword;
  bool basmala;
  SearchMode mode;
  int chapterID;

  SearchSettings(this.keyword, this.basmala, this.mode, this.chapterID);


  static SearchSettings empty(){
    return new SearchSettings("", false, SearchMode.WITHIN, 0);
  } 
}