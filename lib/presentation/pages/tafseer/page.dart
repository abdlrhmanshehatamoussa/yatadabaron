import 'package:Yatadabaron/domain/dtos/verse-dto.dart';
import 'package:Yatadabaron/modules/crosscutting.module.dart';
import 'package:Yatadabaron/modules/domain.module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';

class TafseerPage extends StatelessWidget {
  Widget _tafseerVerseTile({
    required BuildContext context,
    required String verseTextTashkeel,
    required String chapterName,
    required int verseId,
  }) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          verseTextTashkeel,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        subtitle: Text(
          '[$chapterName - $verseId]',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Widget _tafseerTile({
    required BuildContext context,
    required String tafseer,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        tafseer,
        style: TextStyle(fontSize: 15, fontFamily: 'Arial'),
      ),
    );
  }

  Widget _tafseerSelector({
    required TafseerPageBloc bloc,
    required List<TafseerDTO> tafseers,
    required int tafseerId,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerRight,
      child: DropdownButton<int>(
        items: tafseers.map((TafseerDTO dto) {
          return DropdownMenuItem<int>(
            child: Text(dto.tafseerName),
            value: dto.tafseerId,
          );
        }).toList(),
        value: tafseerId,
        onChanged: (int? selection) {
          if (selection != null) {
            bloc.updateTafseerStream(selection);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TafseerPageBloc bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.TAFSEER_PAGE),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: ButtonBar(
            children: [
              IconButton(
                onPressed: () async =>
                    await bloc.onSaveBookmarkClicked(context),
                icon: Icon(Icons.bookmark),
              ),
              IconButton(
                onPressed: () async => await bloc.shareVerse(),
                icon: Icon(Icons.share),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder<List<TafseerDTO>>(
              future: bloc.getAvailableTafseers(),
              builder: (_,
                  AsyncSnapshot<List<TafseerDTO>> availableTafseerSnapshot) {
                if (availableTafseerSnapshot.hasData &&
                    (availableTafseerSnapshot.data?.isNotEmpty ?? false)) {
                  return StreamBuilder<TafseerResultDTO>(
                    stream: bloc.tafseerStream,
                    builder:
                        (_, AsyncSnapshot<TafseerResultDTO> resultSnapshot) {
                      if (resultSnapshot.hasData) {
                        return Column(
                          children: [
                            _tafseerSelector(
                              bloc: bloc,
                              tafseerId: resultSnapshot.data!.tafseerId,
                              tafseers: availableTafseerSnapshot.data!,
                            ),
                            _tafseerVerseTile(
                              context: context,
                              chapterName: resultSnapshot.data!.chapterName,
                              verseTextTashkeel:
                                  resultSnapshot.data!.verseTextTashkeel,
                              verseId: resultSnapshot.data!.verseId,
                            ),
                            _tafseerTile(
                              context: context,
                              tafseer: resultSnapshot.data!.tafseer,
                            ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  static void push(
      BuildContext context, VerseDTO verse, Function onBookmarkSaved) {
    Navigator.of(context).push(_getPageRoute(verse, onBookmarkSaved));
  }

  static MaterialPageRoute _getPageRoute(
      VerseDTO verse, Function onBookmarkSaved) {
    return MaterialPageRoute(
      builder: (context) => Provider(
        child: TafseerPage(),
        create: (contextt) => TafseerPageBloc(
          verse,
          onBookmarkSaved,
        ),
      ),
    );
  }
}
