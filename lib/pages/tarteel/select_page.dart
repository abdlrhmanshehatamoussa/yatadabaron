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
  var reciterKey = "";
  var initialized = false;
  var loading = false;
  var chapterId = 0;
  int start = 0;
  int end = 0;
  List<int> verses = [];
  List<Chapter> chapters = [];

  @override
  void initState() {
    getChapters().then((value) {
      setState(() {
        chapters = value;
        reciterKey = getReciter();
        getTarteelLocation().then((locationArray) {
          chapterId = locationArray[0];
          start = locationArray[1];
          end = locationArray[2];
          var versesCount = chapters
              .firstWhere((element) => element.chapterID == chapterId)
              .verseCount;
          verses = List.generate(versesCount, (i) => i + 1);
          initialized = true;
        });
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
                                child: Text(
                                    "${chapter.chapterID.toArabicNumber()} - ${chapter.chapterNameAR}"),
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
                                  child: Text(verseId.toArabicNumber()),
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
                                  child: Text(verseId.toArabicNumber()),
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
                              await setReciter(reciterKey);
                              await setTarteelLocation(chapterId, start, end);
                              await onClickTarteel(
                                chapterId,
                                start,
                                end,
                                reciterKey,
                              );
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
                        ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  ListTile(
                    title: Text(
                      "من فضلك تأكد من اتصالك بالواي فاي أولاً لتجنب استهلاك كميات كبيرة من الباقة",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.warning,
                    size: 40,
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

  Future<void> setTarteelLocation(int chapterId, int start, int end) async {
    await appSettingsService.updateTarteelLocation([chapterId, start, end]);
  }

  Future<List<int>> getTarteelLocation() async {
    return appSettingsService.currentValue.tarteelLocation.isEmpty
        ? [1, 1, 7]
        : appSettingsService.currentValue.tarteelLocation;
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
            verseText: verse.verseTextTashkel,
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
