import 'package:yatadabaron/domain/dtos/verse-dto.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';
import 'widgets/app_bar.dart';
import 'widgets/selector.dart';
import 'widgets/tafseer_section.dart';
import 'widgets/verse_section.dart';

class TafseerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TafseerPageBloc bloc = Provider.of(context);
    return Scaffold(
      appBar: TafseerAppBar.build(context),
      body: Column(
        children: [
          Divider(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: FutureBuilder<VerseDTO>(
                future: bloc.loadVerseDTO(),
                builder: (_, AsyncSnapshot<VerseDTO> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return VerseSection(
                      chapterName: snapshot.data!.chapterName ?? "",
                      verseTextTashkeel: snapshot.data!.verseTextTashkel ?? "",
                      verseId: snapshot.data!.verseID ?? -1,
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
              future: bloc.getAvailableTafseers(),
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
                    stream: bloc.tafseerStream,
                    builder: (_, AsyncSnapshot<VerseTafseer> resultSnapshot) {
                      if (resultSnapshot.hasData) {
                        return Column(
                          children: [
                            TafseerSelector(
                              tafseerId: resultSnapshot.data!.tafseerSourceID,
                              tafseers: availableTafseerSnapshot.data!,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: TafseerSection(
                                  tafseer: resultSnapshot.data!.tafseerText,
                                  tafseerSourceID:
                                      resultSnapshot.data!.tafseerSourceID,
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

  static void push({
    required BuildContext context,
    required int verseId,
    required int chapterId,
    required Function onBookmarkSaved,
  }) {
    Navigator.of(context).push(
      _getPageRoute(
        verseId: verseId,
        chapterId: chapterId,
        onBookmarkSaved: onBookmarkSaved,
      ),
    );
  }

  static MaterialPageRoute _getPageRoute({
    required int chapterId,
    required int verseId,
    required Function onBookmarkSaved,
  }) {
    return MaterialPageRoute(
      builder: (context) => Provider(
        child: TafseerPage(),
        create: (contextt) => TafseerPageBloc(
          verseId,
          chapterId,
          onBookmarkSaved,
        ),
      ),
    );
  }
}
