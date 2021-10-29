import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class BookmarksController extends BaseController {
  BookmarksController({
    required this.versesService,
    required this.userDataService,
  }) {
    reloadBookmarks();
  }

  final IVersesService versesService;
  final IUserDataService userDataService;

  StreamObject<List<Verse>> _versesStreamObj = StreamObject();
  Stream<List<Verse>> get bookmarkedVersesStream => _versesStreamObj.stream;

  Future<void> reloadBookmarks() async {
    List<Verse> results = [];
    List<MushafLocation> locations = await userDataService.getMushafLocations();
    for (var location in locations) {
      Verse v = await versesService.getSingleVerse(
          location.verseId, location.chapterId);
      results.add(v);
    }
    _versesStreamObj.add(results);
  }

  Future<void> removeBookmark(MushafLocation loc) async {
    await userDataService.removeMushafLocation(loc);
    await reloadBookmarks();
  }
}