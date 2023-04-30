import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/tarteel/page.dart';
import 'playable_item.dart';

class TarteelSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TarteelSelectionPage> with _Controller {
  var chapterId = 1;
  var reciterKey = reciterNameMap.keys.first;
  var loading = false;
  double size = 0;
  final fromController = TextEditingController(text: "1");
  final toController = TextEditingController(text: "1");
  List<Chapter> chapters = [];

  @override
  void initState() {
    getChapters().then((value) {
      setState(() {
        chapters = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ترتيل")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: chapters.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  DropdownButtonFormField<String>(
                    key: UniqueKey(),
                    items: reciterNameMap.keys
                        .map((reciterKey) => DropdownMenuItem<String>(
                              key: UniqueKey(),
                              child: SingleChildScrollView(
                                child: Text(reciterNameMap[reciterKey] ?? ""),
                                padding: EdgeInsets.all(10),
                                scrollDirection: Axis.horizontal,
                              ),
                              value: reciterKey,
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          reciterKey = v;
                        });
                      }
                    },
                    value: reciterKey,
                    isExpanded: true,
                  ),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    items: chapters
                        .map((chapter) => DropdownMenuItem<int>(
                              child: Text(chapter.chapterNameAR),
                              value: chapter.chapterID,
                            ))
                        .toList(),
                    onChanged: loading
                        ? null
                        : (v) {
                            if (v != null) {
                              setState(() {
                                chapterId = v;
                              });
                            }
                          },
                    value: chapterId,
                  ),
                  TextFormField(
                    controller: fromController,
                    decoration: InputDecoration(
                        label: Text("الآية من:"),
                        suffix: GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () => fromController.clear(),
                        )),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: toController,
                    decoration: InputDecoration(
                        label: Text("الآية إلى:"),
                        suffix: GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () => toController.clear(),
                        )),
                    keyboardType: TextInputType.number,
                  ),
                  size > 0
                      ? Text(size.toStringAsFixed(2) + " ميجابايت")
                      : Container(),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () async {
                            setState(() {
                              loading = true;
                            });
                            try {
                              await onClickTarteel(
                                  chapterId,
                                  int.parse(fromController.text),
                                  int.parse(toController.text),
                                  reciterKey);
                            } catch (e) {
                              Utils.showInternetConnectionErrorDialog(context);
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                    child: Icon(
                      Icons.play_circle,
                      size: 150,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class _Controller {
  final verseService = Simply.get<IVersesService>();
  final chapterService = Simply.get<IChaptersService>();
  final audioDownloaderService = Simply.get<IVerseAudioDownloader>();

  Future<List<Chapter>> getChapters() async {
    return await chapterService.getAll();
  }

  Future<void> onClickTarteel(
    int chapterId,
    int start,
    int end,
    String reciterKey,
  ) async {
    var result = <TarteelPlayableItem>[];
    var chapterName =
        (await chapterService.getChapter(chapterId)).chapterNameAR;
    var verses = await verseService.getVersesByChapterId(chapterId, false);
    verses = verses
        .where((element) => element.verseID >= start && element.verseID <= end)
        .toList();
    var audioUrls = await audioDownloaderService.getAudioUrlsOrPath(
        chapterId, start, end, reciterKey);
    for (var i = 0; i < audioUrls.length; i++) {
      var audioUrl = audioUrls[i];
      var verse = verses[i];
      result.add(
        TarteelPlayableItem(
          order: i,
          verseText: verse.verseTextTashkelWithNumber,
          verseId: verse.verseID,
          chapterName: chapterName,
          audioUrl: audioUrl,
        ),
      );
    }

    appNavigator.pushWidget(
      view: TarteelPage(
        playableItems: result,
        reciterName: reciterNameMap[reciterKey] ?? "",
      ),
    );
  }
}
