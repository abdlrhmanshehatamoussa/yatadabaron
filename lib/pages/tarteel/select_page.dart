import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/mushaf/widgets/circular_progress.dart';
import 'package:yatadabaron/pages/tarteel/page.dart';
import 'playable_item.dart';

class TarteelSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TarteelSelectionPage> with _Controller {
  var reciterKey = reciterNameMap.keys.first;
  var loading = false;
  var initialized = false;
  double size = 0;
  var chapterId = 1;
  int start = 1;
  int end = 7;
  List<int> verses = List.generate(7, (i) => i + 1);
  List<Chapter> chapters = [];

  @override
  void initState() {
    getChapters().then((value) {
      setState(() {
        chapters = value;
        reciterKey = getReciter();
        initialized = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ترتيل")),
      body: Container(
        padding: EdgeInsets.all(5),
        child: !initialized
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  DropdownButton<String>(
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
                    onChanged: loading
                        ? null
                        : (v) async {
                            if (v != null) {
                              await setReciter(v);
                              setState(() {
                                reciterKey = v;
                              });
                            }
                          },
                    value: reciterKey,
                    isExpanded: true,
                  ),
                  DropdownButton<int>(
                    key: UniqueKey(),
                    isExpanded: true,
                    items: chapters
                        .map((chapter) => DropdownMenuItem<int>(
                              key: UniqueKey(),
                              child: SingleChildScrollView(
                                child: Text(ArabicNumbers()
                                        .convert(chapter.chapterID.toString()) +
                                    " - " +
                                    chapter.chapterNameAR),
                                padding: EdgeInsets.all(10),
                                scrollDirection: Axis.horizontal,
                              ),
                              value: chapter.chapterID,
                            ))
                        .toList(),
                    onChanged: loading
                        ? null
                        : (v) {
                            if (v != null) {
                              setState(() {
                                chapterId = v;
                                var versesCount = chapters
                                    .firstWhere((c) => c.chapterID == chapterId)
                                    .verseCount;
                                verses =
                                    List.generate(versesCount, (i) => i + 1);
                                start = 1;
                                end = versesCount;
                              });
                            }
                          },
                    value: chapterId,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "من الآية:",
                        textAlign: TextAlign.center,
                      ),
                      DropdownButton<int>(
                        key: UniqueKey(),
                        items: verses
                            .map((verseId) => DropdownMenuItem<int>(
                                  key: UniqueKey(),
                                  child: Text(verseId.toString()),
                                  value: verseId,
                                ))
                            .toList(),
                        onChanged: loading
                            ? null
                            : (v) {
                                if (v != null) {
                                  setState(() {
                                    start = v;
                                  });
                                }
                              },
                        value: start,
                      ),
                      Text(
                        "إلى الآية:",
                        textAlign: TextAlign.center,
                      ),
                      DropdownButton<int>(
                        key: UniqueKey(),
                        items: verses
                            .map((verseId) => DropdownMenuItem<int>(
                                  key: UniqueKey(),
                                  child: Text(verseId.toString()),
                                  value: verseId,
                                ))
                            .toList(),
                        onChanged: loading
                            ? null
                            : (v) {
                                if (v != null) {
                                  setState(() {
                                    end = v;
                                  });
                                }
                              },
                        value: end,
                      )
                    ],
                  ),
                  Divider(
                    height: 25,
                    color: Colors.transparent,
                  ),
                  loading
                      ? CustomCircularProgressIndicator(
                          radius: 150,
                          text: "جاري التحميل",
                        )
                      : TextButton(
                          onPressed: () async {
                            if (start > end) {
                              return;
                            }
                            setState(() {
                              loading = true;
                            });
                            try {
                              await onClickTarteel(
                                  chapterId, start, end, reciterKey);
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
  final appSettingsService = Simply.get<IAppSettingsService>();

  String getReciter() {
    return appSettingsService.currentValue.reciterKey ??
        reciterNameMap.keys.first;
  }

  Future<void> setReciter(String reciterKey) async {
    await appSettingsService.updateReciter(reciterKey);
  }

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
    var audioUrls = [];
    try {
      audioUrls = await audioDownloaderService.getAudioUrlsOrPath(
          chapterId, start, end, reciterKey);
    } catch (e) {
      print("something wrong");
    }

    if (audioUrls.isNotEmpty) {
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
}
