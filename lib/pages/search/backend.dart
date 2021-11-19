import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/commons/utils.dart';
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

  StreamObject<SearchSettings> _settingsBloc = StreamObject();
  StreamObject<SearchResult> _searchResultBloc = StreamObject();
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
    return await chaptersService.getAll(includeWholeQuran: true);
  }

  Stream<SearchResult> get payloadStream => _searchResultBloc.stream;

  Stream<SearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;

  String summary(SearchResult searchResult) {
    if (searchResult.collections.isEmpty) {
      return Localization.EMPTY_SEARCH_RESULTS;
    }
    int chaptersCount = searchResult.collections.length;
    bool wholeQuran = searchResult.settings.searchInWholeQuran;
    String result = Utils.numberTamyeez(
      count: searchResult.totalMatchCount,
      isMasculine: false,
      mothana: Localization.RESULT_MOTHANA,
      plural: Localization.RESULT_PLURAL,
      single: Localization.RESULT,
    );
    if (wholeQuran) {
      return Utils.replaceMultiple(
        Localization.SEARCH_SUMMARY_WHOLE_QURAN,
        "#",
        [
          result,
          searchResult.settings.keyword,
          Utils.numberTamyeez(
            count: chaptersCount,
            single: Localization.SURA_SINGLE,
            plural: Localization.SURA_PLURAL,
            mothana: Localization.SURA_MOTHANA,
            isMasculine: false,
          ),
        ],
      );
    } else {
      return Utils.replaceMultiple(
        Localization.SEARCH_SUMMARY,
        "#",
        [
          result,
          searchResult.settings.keyword,
          searchResult.results.first.verse.chapterName!,
        ],
      );
    }
  }

  Future<void> copyAll(SearchResult searchResult) async {
    String summ = summary(searchResult);
    String toCopy = "$summ\n\n";
    searchResult.results.forEach((VerseSearchResult verseSearchResult) {
      toCopy +=
          "${verseSearchResult.verse.chapterName}\n${verseSearchResult.verse.verseTextTashkel} {${verseSearchResult.verse.verseID}}\n\n";
    });
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
