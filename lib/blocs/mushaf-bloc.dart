import '../blocs/generic-bloc.dart';
import '../dtos/chapter-full-dto.dart';
import '../dtos/chapter-simple-dto.dart';
import '../dtos/verse-dto.dart';
import '../repositories/chapters-repository.dart';
import '../repositories/verses-repository.dart';

class MushafBloc {
  MushafBloc() {
    selectChapter(1);
  }

  GenericBloc<List<VerseDTO>> _versesBloc = GenericBloc();
  GenericBloc<ChapterFullDTO> _selectedChapterBloc = GenericBloc();

  Stream<ChapterFullDTO> get selectedChapterStream => _selectedChapterBloc.stream;
  Stream<List<VerseDTO>> get versesStream => _versesBloc.stream;
  Future selectChapter(int id) async{
    List<VerseDTO> verses = await VersesRepository.instance.getVersesByChapterId(id,false);
    ChapterFullDTO chapter = await ChaptersRepository.instance.getFullChapterById(id);
    _selectedChapterBloc.add(chapter);
    _versesBloc.add(verses);
  }
  Future<List<ChapterSimpleDTO>> get getChaptersSimple async {
    return await ChaptersRepository.instance.getChaptersSimple();
  }
}
