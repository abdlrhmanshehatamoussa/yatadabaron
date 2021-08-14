import 'package:yatadabaron/modules/crosscutting.module.dart';

class ChapterSimpleDTO{
  final int? chapterID;
  final String? chapterNameAR;

  ChapterSimpleDTO(this.chapterID, this.chapterNameAR);

  static ChapterSimpleDTO holyQuran(){
    return ChapterSimpleDTO(0, Localization.WHOLE_QURAN);
  }
}