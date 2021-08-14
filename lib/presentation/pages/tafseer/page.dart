import 'package:yatadabaron/crosscutting/arabic-numbers-service.dart';
import 'package:yatadabaron/domain/dtos/verse-dto.dart';
import 'package:yatadabaron/modules/crosscutting.module.dart';
import 'package:yatadabaron/modules/domain.module.dart';
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
    String verseIdArabic = ArabicNumbersService.insance.convert(verseId);
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          verseTextTashkeel,
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        subtitle: Text(
          '$chapterName - [$verseIdArabic]',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Arabic',
            fontWeight: FontWeight.bold,
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
      padding: EdgeInsets.all(15),
      child: Text(
        tafseer,
        style: TextStyle(fontSize: 17, fontFamily: 'Arial'),
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
            flex: 1,
            child: SingleChildScrollView(
              child: FutureBuilder<VerseDTO>(
                future: bloc.loadVerseDTO(),
                builder: (_, AsyncSnapshot<VerseDTO> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return _tafseerVerseTile(
                      context: context,
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
            child: FutureBuilder<List<TafseerDTO>>(
              future: bloc.getAvailableTafseers(),
              builder: (_,
                  AsyncSnapshot<List<TafseerDTO>> availableTafseerSnapshot) {
                if (availableTafseerSnapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (availableTafseerSnapshot.data?.isEmpty ?? true) {
                  return Center(
                    child: Text("لا يوجد أي تفسيرات حالية"),
                  );
                } else {
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
                            Expanded(
                              child: SingleChildScrollView(
                                child: _tafseerTile(
                                  context: context,
                                  tafseer: resultSnapshot.data!.tafseerText,
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
