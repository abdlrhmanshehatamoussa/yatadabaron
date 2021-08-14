import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/modules/persistence.module.dart';

import 'interface.dart';

class MushafService implements IMushafService {
  MushafService(
    this._chaptersRepository,
    this._versesRepository,
    this._tafseerRepository,
  );

  final ChaptersRepository _chaptersRepository;
  final VersesRepository _versesRepository;
  final TafseerRepository _tafseerRepository;

  //Verses
  //=========
  //Search
  Future<List<VerseDTO>> keywordSearch(bool basmala, String keyword,
      SearchMode searchMode, int chapterID) async {
    return await _versesRepository.search(
        basmala, keyword, searchMode, chapterID);
  }

  //Chapters
  //========
  //Get All Chapters Including Whole-Quran
  Future<List<ChapterSimpleDTO>> getMushafChaptersIncludingWholeQuran() async {
    return await _chaptersRepository.getChaptersSimple(includeWholeQuran: true);
  }

  //Get All Chapters Without Quran
  Future<List<ChapterSimpleDTO>> getMushafChapters() async {
    return await _chaptersRepository.getChaptersSimple(
        includeWholeQuran: false);
  }

  //Get Chapter Name
  Future<String?> getChapterNameById(int chapterID) async {
    return await _chaptersRepository.getChapterNameById(chapterID);
  }

  //Get Full Chapter
  Future<ChapterFullDTO> getFullChapterById(int chapterID) async {
    return await _chaptersRepository.getFullChapterById(chapterID);
  }

  //Get Verses By Chapter ID
  Future<List<VerseDTO>> getVersesByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getVersesByChapterId(chapterId, basmala);
  }

  //Get letters frequency
  Future<List<LetterFrequency>> getLettersByChapterId(
      int chapterId, bool basmala) async {
    return await _versesRepository.getLettersByChapterId(chapterId, basmala);
  }

  @override
  Future<List<TafseerDTO>> getAvailableTafseers() async {
    return await _tafseerRepository.getAvailableTafseers();
  }

  @override
  Future<TafseerResultDTO> getTafseer(
    int tafseerId,
    int verseId,
    int chapterId,
  ) async {
    return await _tafseerRepository.getTafseer(
      chapterId: chapterId,
      verseId: verseId,
      tafseerId: tafseerId,
    );
  }
}
