import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'view_models/statistics-payload.dart';
import 'view_models/statistics-settings.dart';

class StatisticsBackend extends SimpleBackend {
  StatisticsBackend(BuildContext context) : super(context) {
    _stateBloc.add(SearchState.INITIAL);
  }

  late IAnalyticsService analyticsService = getService<IAnalyticsService>();
  late IChaptersService chaptersService = getService<IChaptersService>();
  late IVersesService versesService = getService<IVersesService>();

  StreamObject<StatisticsSettings> _settingsBloc = StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<StatisticsPayload> _payloadBloc = StreamObject();

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
    return await chaptersService.getAll();
  }
}
