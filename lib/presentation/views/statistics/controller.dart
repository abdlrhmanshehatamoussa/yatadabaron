import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'view_model/statistics-settings.dart';
import 'view_model/statistics-payload.dart';

class StatisticsController {
  StatisticsController() {
    _stateBloc.add(SearchState.INITIAL);
  }

  CustomStreamController<StatisticsSettings> _settingsBloc = CustomStreamController();
  CustomStreamController<SearchState> _stateBloc = CustomStreamController();
  CustomStreamController<StatisticsPayload> _payloadBloc = CustomStreamController();

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
          await ServiceManager.instance.mushafService.getChapterName(settings.chapterId);
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

  Future<List<Chapter>> getMushafChapters() async {
    return await ServiceManager.instance.mushafService.getAll(includeWholeQuran:true);
  }
}
