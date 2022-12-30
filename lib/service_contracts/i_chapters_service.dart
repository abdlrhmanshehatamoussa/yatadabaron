import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';

abstract class IChaptersService extends SimpleService {
  //Get All Chapters Without Quran
  Future<List<Chapter>> getAll();

  //Get Chapter Name
  Future<String> getChapterName(int chapterID);

  //Get Full Chapter
  Future<Chapter> getChapter(int chapterID);
}
