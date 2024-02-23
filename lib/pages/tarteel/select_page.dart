import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/_widgets/reciter_selector.dart';
import 'package:yatadabaron/pages/mushaf/widgets/circular_progress.dart';
import 'package:yatadabaron/pages/tarteel/page.dart';
import 'playable_item.dart';

class TarteelSelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TarteelSelectionPage> with _Controller {
  String? reciterKey;
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
        reciterKey = getCachedReciterOrDefault();
        getTarteelLocationOrDefault().then((locationArray) {
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
                    Expanded(
                      child: Column(
                        children: [
                          ReciterSelector(
                            onChanged: loading
                                ? null
                                : (v) async {
                                    if (v != null) {
                                      setState(() {
                                        reciterKey = v;
                                      });
                                    }
                                  },
                            initialValue: reciterKey,
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
                                            .firstWhere(
                                                (c) => c.chapterID == chapterId)
                                            .verseCount;
                                        verses = List.generate(
                                            versesCount, (i) => i + 1);
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
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    var jump = end - start + 1;
                                    var oldStart = start;
                                    start = max(start - jump, 1);
                                    end -= oldStart - start;
                                  });
                                },
                                icon: Icon(Icons.skip_next),
                              ),
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
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    var versesCount = verses.reduce(max);
                                    var jump = end - start + 1;
                                    var oldEnd = end;
                                    end = min(end + jump, versesCount);
                                    start += end - oldEnd;
                                  });
                                },
                                icon: Icon(Icons.skip_previous),
                              ),
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
                                      if (reciterKey != null) {
                                        await setCachedReciter(reciterKey!);
                                        await setTarteelLocation(
                                            chapterId, start, end);
                                        await onClickTarteel(
                                          chapterId,
                                          start,
                                          end,
                                          reciterKey!,
                                        );
                                      }
                                    } catch (e) {
                                      Utils.showInternetConnectionErrorDialog(
                                          context);
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "⚠ من فضلك تأكد من اتصالك بالواي فاي أولاً لتجنب استهلاك كميات كبيرة من الباقة",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    )
                  ],
                )),
    );
  }
}

class _Controller {
  final verseService = Simply.get<IVersesService>();
  final chapterService = Simply.get<IChaptersService>();
  final audioDownloaderService = Simply.get<IVerseAudioDownloader>();
  final tarteelService = Simply.get<ITarteelService>();
  final appSettingsService = Simply.get<IAppSettingsService>();
  final mushafTypeService = Simply.get<IMushafTypeService>();

  MushafType get currentMushafType => mushafTypeService.getMushafType();

  String? getCachedReciterOrDefault() {
    return tarteelService.getCachedReciterKey(currentMushafType) ??
        tarteelService.getReciterKeys(currentMushafType).first;
  }

  Future<void> setCachedReciter(String reciterKey) async {
    await tarteelService.setCachedReciterKey(reciterKey, currentMushafType);
  }

  Future<void> setTarteelLocation(int chapterId, int start, int end) async {
    await tarteelService
        .setTarteelLocationCache([chapterId, start, end], currentMushafType);
  }

  Future<List<int>> getTarteelLocationOrDefault() async {
    return tarteelService.getTarteelLocationCache(currentMushafType) ??
        [1, 1, 2];
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
    var verses = await verseService.getVersesByChapterId(chapterId);
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
            chapterId: chapterId,
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
          reciterName: tarteelService.getReciterName(reciterKey),
        ),
      );
    }
  }
}
