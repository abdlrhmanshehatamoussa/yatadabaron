import 'package:yatadabaron/modules/application.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:yatadabaron/presentation/modules/controllers.module.dart';
import 'package:flutter/foundation.dart';
import 'view_models/search-session-payload.dart';
import 'view_models/search-settings.dart';

class SearchSessionController {
  SearchSessionController() {
    _stateBloc.add(SearchState.INITIAL);
  }

  CustomStreamController<SearchSettings> _settingsBloc = CustomStreamController();
  CustomStreamController<SearchSessionPayload> _payloadBloc = CustomStreamController();
  CustomStreamController<SearchState> _stateBloc = CustomStreamController();
  CustomStreamController<Exception> _errorStream = CustomStreamController();

  Future changeSettings(SearchSettings settings) async {
    String log =
        "KEYWORD=${settings.keyword}|MODE=${describeEnum(settings.mode)}|LOCATION=${settings.chapterID}|BASMALA=${settings.basmala}";
    ServiceManager.instance.analyticsService.logFormFilled("SEARCH FORM", payload: log);
    if (settings.keyword.isEmpty) {
      _stateBloc.add(SearchState.INVALID_SETTINGS);
      return;
    }

    _stateBloc.add(SearchState.IN_PROGRESS);
    List<Verse> results;
    SearchSessionPayload payload;

    try {
      results = await ServiceManager.instance.mushafService.keywordSearch(settings.basmala,
          settings.keyword, settings.mode, settings.chapterID);
      String? chapterName =
          await ServiceManager.instance.mushafService.getChapterName(settings.chapterID);
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

  Future<List<Chapter>> getMushafChapters() async {
    return await ServiceManager.instance.mushafService.getAll(includeWholeQuran:true);
  }

  Stream<SearchSessionPayload> get payloadStream => _payloadBloc.stream;

  Stream<SearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;
}
