import 'package:flutter/foundation.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/controller.dart';
import 'view_models/search-session-payload.dart';
import 'view_models/search-settings.dart';

class SearchController implements ISimpleController {
  final IChaptersService chaptersService;
  final IVersesService versesService;
  final IAnalyticsService analyticsService;

  SearchController({
    required this.analyticsService,
    required this.chaptersService,
    required this.versesService,
  }) {
    _stateBloc.add(SearchState.INITIAL);
  }

  StreamObject<SearchSettings> _settingsBloc = StreamObject();
  StreamObject<SearchSessionPayload> _payloadBloc = StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<Exception> _errorStream = StreamObject();

  Future changeSettings(SearchSettings settings) async {
    String log =
        "KEYWORD=${settings.keyword}|MODE=${describeEnum(settings.mode)}|LOCATION=${settings.chapterID}|BASMALA=${settings.basmala}";
    analyticsService.logFormFilled("SEARCH FORM", payload: log);
    if (settings.keyword.isEmpty) {
      _stateBloc.add(SearchState.INVALID_SETTINGS);
      return;
    }

    _stateBloc.add(SearchState.IN_PROGRESS);
    List<Verse> results;
    SearchSessionPayload payload;

    try {
      results = await versesService.keywordSearch(settings.basmala,
          settings.keyword, settings.mode, settings.chapterID);
      String? chapterName =
          await chaptersService.getChapterName(settings.chapterID);
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
    return await chaptersService.getAll(includeWholeQuran: true);
  }

  Stream<SearchSessionPayload> get payloadStream => _payloadBloc.stream;

  Stream<SearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;

  Future<void> copyAll(SearchSessionPayload payload) async {
    String toCopy = payload.copyAllString();
    Share.share(toCopy);
  }

  Future<void> copyVerse(Verse verse) async {
    String toCopy =
        "${verse.chapterName}\n${verse.verseTextTashkel} {${verse.verseID}}";
    analyticsService.logOnTap("SHARE VERSE");
    Share.share(toCopy);
  }
}
