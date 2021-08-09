import 'package:Yatadabaron/modules/application.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:Yatadabaron/presentation/shared-blocs.module.dart';

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
    String payload =
        "LOCATION=${settings.chapterId}|BASMALA=${settings.basmala}";
    ServiceManager.instance.analyticsService.logFormFilled(
      "STATISTICS FORM",
      payload: payload,
    );
    this._settingsBloc.add(settings);
    _stateBloc.add(SearchState.IN_PROGRESS);

    try {
      String? chapterName =
          await ServiceManager.instance.mushafService.getChapterNameById(settings.chapterId);
      List<LetterFrequency> letterFreqs = await ServiceManager.instance.mushafService
          .getLettersByChapterId(settings.chapterId, settings.basmala);
      _payloadBloc
          .add(StatisticsPayload(chapterName, settings.basmala, letterFreqs));
    } catch (e) {
      _stateBloc.add(SearchState.INITIAL);
      return;
    }

    _stateBloc.add(SearchState.DONE);
  }

  Future<List<ChapterSimpleDTO>> getMushafChapters() async {
    return await ServiceManager.instance.mushafService.getMushafChaptersIncludingWholeQuran();
  }
}