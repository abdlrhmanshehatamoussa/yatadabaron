import '../blocs/generic-bloc.dart';
import '../dtos/letter-frequency.dart';
import '../dtos/statistics-settings.dart';
import '../dtos/statistics-payload.dart';
import '../enums/enums.dart';
import '../repositories/chapters-repository.dart';
import '../repositories/verses-repository.dart';

class StatisticsBloc {
  StatisticsBloc() {
    _stateBloc.add(SearchState.INITIAL);
  }

  GenericBloc<StatisticsSettings> _settingsBloc = GenericBloc();
  GenericBloc<SearchState> _stateBloc = GenericBloc();
  GenericBloc<StatisticsPayload> _payloadBloc = GenericBloc();

  Stream<StatisticsSettings> get settingsStream => _settingsBloc.stream;
  Stream<SearchState> get stateStream => _stateBloc.stream;
  Stream<StatisticsPayload> get payloadStream => _payloadBloc.stream;

  Future changeSettings(StatisticsSettings settings) async {
    this._settingsBloc.add(settings);
    _stateBloc.add(SearchState.IN_PROGRESS);

    try {
      String chapterName = await ChaptersRepository.instance.getChapterNameById(settings.chapterId);
      List<LetterFrequency> letterFreqs = await VersesRepository.instance.getLettersByChapterId(settings.chapterId,settings.basmala);
      _payloadBloc.add(StatisticsPayload(chapterName,settings.basmala,letterFreqs));
    } catch (e) {
      _stateBloc.add(SearchState.INITIAL);
      return;
    }

    _stateBloc.add(SearchState.DONE);
  }
}
