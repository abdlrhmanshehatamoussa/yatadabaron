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
  StreamObject<SearchResult> _payloadBloc = StreamObject();
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
    SearchResult payload;

    try {
      results = await versesService.keywordSearch(settings.basmala,
          settings.keyword, settings.mode, settings.chapterID);
      List<VerseCollection> collections = VerseCollection.group(results);
      payload = SearchResult(settings, collections);
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

  Stream<SearchResult> get payloadStream => _payloadBloc.stream;

  Stream<SearchSettings> get settingsStream => _settingsBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;

  String summary(SearchResult searchResult) {
    if (searchResult.collections.isEmpty) {
      return Localization.EMPTY_SEARCH_RESULTS;
    }
    int chaptersCount = searchResult.collections.length;
    bool searchInWholeQuran = searchResult.settings.chapterID == 0;
    String result = Utils.numberTamyeez(
      count: searchResult.totalCount,
      isMasculine: false,
      mothana: Localization.RESULT_MOTHANA,
      plural: Localization.RESULT_PLURAL,
      single: Localization.RESULT,
    );
    if (searchInWholeQuran) {
      return Utils.replaceMultiple(
        Localization.SEARCH_SUMMARY_WHOLE_QURAN,
        "#",
        [
          result,
          searchResult.settings.keyword,
          Utils.numberTamyeez(
            count: chaptersCount,
            isMasculine: false,
            mothana: "سورتان",
            plural: "سور",
            single: "سورة",
          ),
        ],
      );
    } else {
      return Utils.replaceMultiple(
        Localization.SEARCH_SUMMARY,
        "#",
        [
          Utils.convertToArabiNumber(
            searchResult.totalCount,
            reverse: false,
          ),
          searchResult.settings.keyword,
          searchResult.collections.first.verses.first.chapterName!,
        ],
      );
    }
  }

  Future<void> copyAll(SearchResult searchResult) async {
    String summ = summary(searchResult);
    String toCopy = "$summ\n\n";
    searchResult.verses.forEach((Verse verseDTO) {
      toCopy +=
          "${verseDTO.chapterName}\n${verseDTO.verseTextTashkel} {${verseDTO.verseID}}\n\n";
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
