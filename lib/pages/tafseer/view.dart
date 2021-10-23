import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/mvc/base_view.dart';
import 'controller.dart';
import 'widgets/app_bar.dart';
import 'widgets/selector.dart';
import 'widgets/tafseer_section.dart';
import 'widgets/verse_section.dart';

class TafseerPage extends BaseView<TafseerPageController> {
  TafseerPage(TafseerPageController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder<Verse>(
                future: controller.loadVerseDTO(),
                builder: (_, AsyncSnapshot<Verse> snapshot) {
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
              future: controller.getAvailableTafseers(),
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
}
