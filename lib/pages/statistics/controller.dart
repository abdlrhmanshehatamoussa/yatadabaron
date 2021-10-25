import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/services/interfaces/i_analytics_service.dart';
import 'package:yatadabaron/services/interfaces/i_chapters_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'view_models/statistics-payload.dart';
import 'view_models/statistics-settings.dart';

class StatisticsController extends BaseController {
  final IAnalyticsService analyticsService;
  final IChaptersService chaptersService;
  final IVersesService versesService;

  StatisticsController({
    required this.analyticsService,
    required this.chaptersService,
    required this.versesService,
  }) {
    _stateBloc.add(SearchState.INITIAL);
  }

  StreamObject<StatisticsSettings> _settingsBloc =
      StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<StatisticsPayload> _payloadBloc =
      StreamObject();

  Stream<StatisticsSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<StatisticsPayload> get payloadStream => _payloadBloc.stream;

  Future changeSettings(StatisticsSettings settings) async {
    String payload =
        "LOCATION=${settings.chapterId}|BASMALA=${settings.basmala}";
    analyticsService.logFormFilled(
      "STATISTICS FORM",
      payload: payload,
    );
    this._settingsBloc.add(settings);
    _stateBloc.add(SearchState.IN_PROGRESS);

    try {
      String? chapterName =
          await chaptersService.getChapterName(settings.chapterId);
      List<LetterFrequency> letterFreqs = await versesService
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
    return await chaptersService.getAll(includeWholeQuran: true);
  }
}
