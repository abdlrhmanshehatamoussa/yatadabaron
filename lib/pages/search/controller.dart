import 'package:share/share.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/stream_object.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/mushaf/view.dart';
import 'package:simply/simply.dart';
import '../_viewmodels/module.dart';

class SearchController {
  SearchController() {
    _stateBloc.add(SearchState.INITIAL);
  }

  late IChaptersService chaptersService = Simply.get<IChaptersService>();
  late IVersesService versesService = Simply.get<IVersesService>();
  late IEventLogger eventLogger = Simply.get<IEventLogger>();

  KeywordSearchSettings settings = KeywordSearchSettings();
  StreamObject<SearchResult> _searchResultBloc = StreamObject();
  StreamObject<SearchState> _stateBloc = StreamObject();
  StreamObject<Exception> _errorStream = StreamObject();

  Future changeSettings(KeywordSearchSettings settings) async {
    this.settings = settings;
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
      _errorStream.add(Exception(Localization.SEARCH_ERROR));
      return;
    }
  }

  Future<List<Chapter>> getMushafChapters() async {
    return await chaptersService.getAll();
  }

  Stream<SearchResult> get payloadStream => _searchResultBloc.stream;

  Stream<SearchState> get stateStream => _stateBloc.stream;

  Stream<Exception> get errorStream => _errorStream.stream;

  Future<void> share(String toCopy) async {
    Share.share(toCopy);
  }

  Future<void> copyVerse(Verse verse) async {
    String toCopy =
        "${verse.chapterName}\n${verse.verseTextTashkel} {${verse.verseID}}";
    eventLogger.logTapEvent(description: "share_verse");
    Share.share(toCopy);
  }

  Future<void> goMushafPage(Verse verse) async {
    int chapterId = verse.chapterId;
    int verseID = verse.verseID;
    appNavigator.pushWidget(
      view: MushafPage(
        mushafSettings: MushafSettings.fromSearch(
          chapterId: chapterId,
          verseId: verseID,
        ),
      ),
    );
  }
}
