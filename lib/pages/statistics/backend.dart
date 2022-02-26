import 'package:flutter/material.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/simple/_module.dart';
import 'view_models/statistics-payload.dart';

class StatisticsBackend extends SimpleBackend {
  StatisticsBackend(BuildContext context) : super(context) {
    _stateBloc.add(SearchState.INITIAL);
  }

  late IChaptersService chaptersService = getService<IChaptersService>();
  late IVersesService versesService = getService<IVersesService>();

  StreamObject<BasicSearchSettings> _settingsBloc = StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<StatisticsPayload> _payloadBloc = StreamObject();

  Stream<BasicSearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<StatisticsPayload> get payloadStream => _payloadBloc.stream;

  Future changeSettings(BasicSearchSettings settings) async {
    this._settingsBloc.add(settings);
    _stateBloc.add(SearchState.IN_PROGRESS);

    try {
      String chapterName;
      int? chId = settings.chapterId;
      if (chId != null) {
        chapterName = await chaptersService.getChapterName(chId);
      } else {
        chapterName = Localization.WHOLE_QURAN;
      }
      List<LetterFrequency> letterFreqs =
          await versesService.getLetterFrequency(settings);
      _payloadBloc.add(StatisticsPayload(
        chapterName,
        settings.basmala,
        letterFreqs,
      ));
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
