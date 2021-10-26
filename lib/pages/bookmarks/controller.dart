import 'package:yatadabaron/commons/base_controller.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/interfaces/i_user_data_service.dart';
import 'package:yatadabaron/services/interfaces/i_verses_service.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class BookmarksController extends BaseController {
  final IVersesService versesService;
  final IUserDataService userDataService;

  BookmarksController({
    required this.versesService,
    required this.userDataService,
  });

  Future<List<Verse>> getBookmarkedVerses() async {
    List<Verse> results = [];
    List<MushafLocation> locations = await userDataService.getMushafLocations();
    for (var location in locations) {
      Verse v = await versesService.getSingleVerse(
          location.verseId, location.chapterId);
      results.add(v);
    }
    return results;
  }
}
