import 'package:yatadabaron/models/module.dart';

abstract class IChaptersService{
  //Get All Chapters Without Quran
  Future<List<Chapter>> getAll();

  //Get Chapter Name
  Future<String> getChapterName(int chapterID);

  //Get Full Chapter
  Future<Chapter> getChapter(int chapterID);
}
