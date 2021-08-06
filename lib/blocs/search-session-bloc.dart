import 'package:Yatadabaron/services/analytics-service.dart';
import 'package:flutter/foundation.dart';

import '../blocs/generic-bloc.dart';
import '../dtos/verse-dto.dart';
import '../dtos/search-settings.dart';
import '../dtos/search-session-payload.dart';
import '../enums/enums.dart';
import '../repositories/chapters-repository.dart';
import '../repositories/verses-repository.dart';

class SearchSessionBloc {
  SearchSessionBloc() {
    _stateBloc.add(SearchState.INITIAL);
  }

  GenericBloc<SearchSettings> _settingsBloc = GenericBloc();
  GenericBloc<SearchSessionPayload> _payloadBloc = GenericBloc();
  GenericBloc<SearchState> _stateBloc = GenericBloc();
  GenericBloc<Exception> _errorStream = GenericBloc();

  Future changeSettings(SearchSettings settings) async {
    String log =
        "KEYWORD=${settings.keyword}|MODE=${describeEnum(settings.mode)}|LOCATION=${settings.chapterID}|BASMALA=${settings.basmala}";
    AnalyticsService.instance.logFormFilled("SEARCH FORM", payload: log);
    if (settings.keyword.isEmpty) {
      _stateBloc.add(SearchState.INVALID_SETTINGS);
      return;
    }

    _stateBloc.add(SearchState.IN_PROGRESS);
    List<VerseDTO> results;
    SearchSessionPayload payload;

    try {
      results = await VersesRepository.instance.search(settings.basmala,
          settings.keyword, settings.mode, settings.chapterID);
      String? chapterName = await ChaptersRepository.instance
          .getChapterNameById(settings.chapterID);
      payload = SearchSessionPayload(settings, chapterName, results);
    } catch (e) {
      _stateBloc.add(SearchState.INITIAL);
      _errorStream
          .add(Exception("Error occurred while connecting to database"));
      return;
    }

    _payloadBloc.add(payload);
    _stateBloc.add(SearchState.DONE);
  }

  Stream<SearchSessionPayload> get payloadStream => _payloadBloc.stream;
  Stream<SearchSettings> get settingsStream => _settingsBloc.stream;
  Stream<SearchState> get stateStream => _stateBloc.stream;
  Stream<Exception> get errorStream => _errorStream.stream;
}
