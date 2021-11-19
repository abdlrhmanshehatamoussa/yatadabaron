import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class SearchBackend extends SimpleBackend {
  SearchBackend(BuildContext context) : super(context) {
    _stateBloc.add(SearchState.INITIAL);
  }

  late IChaptersService chaptersService = getService<IChaptersService>();
  late IVersesService versesService = getService<IVersesService>();
  late IAnalyticsService analyticsService = getService<IAnalyticsService>();

  StreamObject<KeywordSearchSettings> _settingsBloc = StreamObject();
  StreamObject<SearchResult> _searchResultBloc = StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<Exception> _errorStream = StreamObject();

  Future changeSettings(KeywordSearchSettings settings) async {
    String log =
        "KEYWORD=${settings.keyword}|MODE=${describeEnum(settings.mode)}|LOCATION=${settings.chapterID}|BASMALA=${settings.basmala}";
    analyticsService.logFormFilled("SEARCH FORM", payload: log);
    if (settings.keyword.isEmpty) {
      _stateBloc.add(SearchState.INVALID_SETTINGS);
      return;
    }

    _stateBloc.add(SearchState.IN_PROGRESS);

    try {
      SearchResult result = await versesService.keywordSearch(settings);
      _searchResultBloc.add(result);
      _stateBloc.add(SearchState.DONE);
    } catch (e) {
      _stateBloc.add(SearchState.INITIAL);
      _errorStream
          .add(Exception("Error occurred while connecting to database"));
      return;
    }
  }

  Future<List<Chapter>> getMushafChapters() async {
    return await chaptersService.getAll();
  }

  Stream<SearchResult> get payloadStream => _searchResultBloc.stream;

  Stream<KeywordSearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;

  Future<void> share(String toCopy) async {
    Share.share(toCopy);
  }

  Future<void> copyVerse(Verse verse) async {
    String toCopy =
        "${verse.chapterName}\n${verse.verseTextTashkel} {${verse.verseID}}";
    analyticsService.logOnTap("SHARE VERSE");
    Share.share(toCopy);
  }

  Future<void> goMushafPage(Verse verse) async {
    int chapterId = verse.chapterId;
    int verseID = verse.verseID;
    navigatePush(
      view: MushafPage(
        mushafSettings: MushafSettings.fromSearch(
          chapterId: chapterId,
          verseId: verseID,
        ),
      ),
    );
  }
}
