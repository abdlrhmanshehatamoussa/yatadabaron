import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/tafseer/controller.dart';
import 'package:yatadabaron/services/interfaces/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/viewmodels/module.dart';
import 'widgets/app_bar.dart';
import 'widgets/selector.dart';
import 'widgets/tafseer_section.dart';
import 'widgets/verse_section.dart';

class TafseerPage extends SimpleView<TafseerPageController> {
  final MushafLocation location;

  TafseerPage({
    required this.location,
  });

  Future<void> _handleAfterBookmarkSaved(
      BuildContext context, bool done) async {
    if (done) {
      await Utils.showCustomDialog(
        context: context,
        title: Localization.BOOKMARK_SAVED,
      );
    } else {
      await Utils.showCustomDialog(
        context: context,
        title: Localization.BOOKMARK_ALREADY_EXISTS,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TafseerPageController controller = getController(context);
    return Scaffold(
      appBar: TafseerAppBar.build(
        context: context,
        onShare: () async => await controller.shareVerse(this.location),
        onSaveBookmark: () async {
          bool done =
              await controller.onSaveBookmarkClicked(context, this.location);
          await _handleAfterBookmarkSaved(context, done);
        },
      ),
      body: Column(
        children: [
          Divider(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: FutureBuilder<Verse>(
                future: controller.loadVerseDTO(this.location),
                builder: (_, AsyncSnapshot<Verse> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return VerseSection(
                      chapterName: snapshot.data!.chapterName ?? "",
                      verseTextTashkeel: snapshot.data!.verseTextTashkel,
                      verseId: snapshot.data!.verseID,
                    );
                  }
                },
              ),
            ),
          ),
          Divider(
            height: 5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder<List<TafseerSource>>(
              future: controller.getAvailableTafseers(this.location),
              builder: (_,
                  AsyncSnapshot<List<TafseerSource>> availableTafseerSnapshot) {
                if (availableTafseerSnapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (availableTafseerSnapshot.data?.isEmpty ?? true) {
                  return Center(
                    child: Text(Localization.NO_TRANSLATIONS_AVAILABLE),
                  );
                } else {
                  return StreamBuilder<VerseTafseer>(
                    stream: controller.tafseerStream,
                    builder: (_, AsyncSnapshot<VerseTafseer> resultSnapshot) {
                      if (resultSnapshot.hasData) {
                        VerseTafseer result = resultSnapshot.data!;
                        return Column(
                          children: [
                            TafseerSelector(
                              tafseerId: result.tafseerSourceID,
                              tafseers: availableTafseerSnapshot.data!,
                              onTafseerSourceSelected: (int id) async {
                                await controller.updateTafseerStream(
                                  this.location,
                                  id,
                                );
                              },
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: TafseerSection(
                                  tafseer: result.tafseerText,
                                  tafseerSourceID: result.tafseerSourceID,
                                  onDownloadSource: (int id) async {
                                    controller.downloadTafseerSource(
                                      id,
                                      location,
                                      context,
                                    );
                                  },
                                  getTafseerSize: controller
                                      .getTafseerSizeMB(result.tafseerSourceID),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  TafseerPageController provideController(
    ISimpleServiceProvider serviceProvider,
  ) {
    return TafseerPageController(
      analyticsService: serviceProvider.getService<IAnalyticsService>(),
      userDataService: serviceProvider.getService<IUserDataService>(),
      versesService: serviceProvider.getService<IVersesService>(),
      tafseerService: serviceProvider.getService<ITafseerService>(),
      tafseerSourcesService:
          serviceProvider.getService<ITafseerSourcesService>(),
    );
  }
}
