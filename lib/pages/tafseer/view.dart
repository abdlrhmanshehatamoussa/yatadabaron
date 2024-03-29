import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/pages/tafseer/controller.dart';
import 'package:yatadabaron/pages/tafseer/widgets/play_widget.dart';
import '../_viewmodels/module.dart';
import 'widgets/selector.dart';
import 'widgets/tafseer_section.dart';
import 'widgets/verse_section.dart';

class TafseerPage extends StatelessWidget {
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
    TafseerPageController backend = TafseerPageController(
      location: location,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.TAFSEER_PAGE),
        actions: [
          IconButton(
            onPressed: () async {
              bool done = await backend.onSaveBookmarkClicked();
              await _handleAfterBookmarkSaved(context, done);
            },
            icon: Icon(Icons.bookmark_add_sharp),
          ),
          IconButton(
            onPressed: () async => await backend.shareVerse(),
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: Column(
        children: [
          Divider(
            height: 5,
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: FutureBuilder<Verse>(
                future: backend.loadVerseDTO(),
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
            flex: 3,
            child: FutureBuilder<List<TafseerSource>>(
              future: backend.getAvailableTafseers(),
              builder: (_,
                  AsyncSnapshot<List<TafseerSource>> availableTafseerSnapshot) {
                if (availableTafseerSnapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (availableTafseerSnapshot.data?.isEmpty ?? true) {
                  return Center(
                    child: Text(
                      Localization.INTERNET_CONNECTION_ERROR,
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return StreamBuilder<VerseTafseer>(
                    stream: backend.tafseerStream,
                    builder: (_, AsyncSnapshot<VerseTafseer> resultSnapshot) {
                      if (resultSnapshot.hasData) {
                        VerseTafseer result = resultSnapshot.data!;
                        return Column(
                          children: [
                            TafseerSelector(
                              tafseerId: result.tafseerSourceID,
                              tafseers: availableTafseerSnapshot.data!,
                              onTafseerSourceSelected: (int id) async {
                                await backend.updateTafseerStream(id);
                              },
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: TafseerSection(
                                  tafseer: result.tafseerText,
                                  tafseerSourceID: result.tafseerSourceID,
                                  onDownloadSource: (int id) async {
                                    await backend.downloadTafseerSource(
                                      id,
                                      context,
                                    );
                                  },
                                  getTafseerSize: backend.getTafseerSizeMB(
                                    result.tafseerSourceID,
                                  ),
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
          Divider(
            height: 5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: VersePlayWidget(
              verseId: location.verseId,
              chapterId: location.chapterId,
            ),
          )
        ],
      ),
    );
  }
}
