import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/simple/module.dart';

abstract class IChaptersService extends SimpleService<IChaptersService> {
  //Get All Chapters Without Quran
  Future<List<Chapter>> getAll({required bool includeWholeQuran});

  //Get Chapter Name
  Future<String?> getChapterName(int chapterID);

  //Get Full Chapter
  Future<Chapter> getChapter(int chapterID);
}
